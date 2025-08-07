
// DialogDlg.cpp: 实现文件
//

#include "pch.h"
#include "framework.h"
#include "Dialog.h"
#include "DialogDlg.h"
#include "afxdialogex.h"
#include <dbt.h>
#include "CyAPI.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

#define     MAX_QUEUE_SZ                        64
#define     TIMEOUT_PER_TRANSFER_MILLI_SEC      1500

#define USBD_STATUS_ENDPOINT_HALTED     0xC0000030

// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CDialogDlg 对话框
#define DATA_SHOW_LENGTH 1000
#define DATA_PAGE_LENGTH 1024
#define IDTIMER1 1
#define IDTIMER2 2

unsigned short g_xBuff[DATA_SHOW_LENGTH] = { 0 };
unsigned short g_yBuff[DATA_SHOW_LENGTH] = { 0 };
UCHAR g_buffersTrigResult[DATA_PAGE_LENGTH] = { 0 };
bool g_bKInstructionSend = FALSE;
int g_daoLianIndex = 16;
bool g_bButtonUSBTrigClicked = FALSE;
bool g_bButtonUARTTrigClicked = FALSE;
int g_writeIndex = 0;
//int g_saveIndex = 0;
int g_frameNumber = 32767;
bool g_frameCheakStart = FALSE; // FPGA外，USB FIFO中可能存有一帧数据，所以需要从第二帧开始校验
UCHAR g_triggerValue = 0x31;
UCHAR g_uartTrigValue = 0x31;
UINT g_samplingRate = 24000;

namespace {
	UCHAR INT2ASCII(int n)
	{
		if (n < 10)
		{
			return 0x30 + n;
		}
		else if (n < 16)
		{
			return 'A' + n - 10;
		}
		return -1;
	}

	int ASCII2INT(UCHAR ascii)
	{
		if ((ascii >= '0') && (ascii <= '9'))
		{
			return ascii - '0';
		}
		else if ((ascii >= 'A') && (ascii <= 'Z'))
		{
			return ascii - 'A' + 10;
		}
		else if ((ascii >= 'a') && (ascii <= 'a'))
		{
			return ascii - 'a' + 10;
		}
		return -1;
	}

	UCHAR g_atParameter[100] = { 0 };
	long g_atParameterLength = 0;
	UCHAR g_atInstruction[100] = { 0 };
	long g_atInstructionLength = 0;

	void BuildAtParameterSampleRate(UINT samplingRate)
	{
		g_atParameterLength = 12;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		sprintf((char*)g_atParameter, "0002%08X", samplingRate);
	}

	void BuildAtParameterTriggerValue(UCHAR value)
	{
		g_atParameterLength = 12;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		sprintf((char*)g_atParameter, "0003%08X", value);
	}

	void BuildAtParameterDlNum(UINT dlNum)
	{
		g_atParameterLength = 12;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		if (dlNum != 0)
		{
			sprintf((char*)g_atParameter, "00050000%d%03d", 1, dlNum);
		}
		else
		{
			sprintf((char*)g_atParameter, "00050000%d%03d", 0, dlNum);
		}
	}

	void BuildAtParameterSampleRateEx()
	{
		g_atParameterLength = 25;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		UINT triggerLength = 0x320;
		UINT samplingRateEx = 48000000 / g_samplingRate;
		sprintf((char*)g_atParameter, "%02X%02X12345678%08X876FC", samplingRateEx & 0xff, (samplingRateEx >> 8) & 0xff, triggerLength);
	}

	void BuildAtParameterStop()
	{
		g_atParameterLength = 1;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		g_atParameter[0] = 0x30;
	}

	void BuildAtParameterQuery()
	{
		g_atParameterLength = 1;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		g_atParameter[0] = 0x30;
	}

	void BuildAtParameterUartRead()
	{
		g_atParameterLength = 1;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		g_atParameter[0] = 0x78;		// x
	}

	void BuildAtParameterUartWrite(CString write)
	{
		g_atParameterLength = 12;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		sprintf((char*)g_atParameter, "%08d%04d", atoi(write.Mid(2, 8)), atoi(write.Mid(10, 4)));
	}

	void BuildAtParameterUartTrig(UCHAR value)
	{
		g_atParameterLength = 2;
		memset(g_atParameter, 0, sizeof(g_atParameter));
		sprintf((char*)g_atParameter, "%02d", value);
	}

	void BuildAtInstruction(UCHAR cmdByte)
	{
		int i;
		unsigned char chAt = 0x40;		// @
		unsigned char chAnd = 0x26;		// &
		unsigned char chSharp = 0x23;	// #
		unsigned char check = 0;

		memset(g_atInstruction, 0, sizeof(g_atInstruction));

		g_atInstruction[0] = chAt;				// start flag
		g_atInstruction[1] = cmdByte;			// command

		memcpy(&g_atInstruction[2], g_atParameter, g_atParameterLength);

		check = cmdByte;
		for (i = 0; i < g_atParameterLength; i++)
		{
			check += g_atParameter[i];
		}

		g_atInstruction[2 + g_atParameterLength] = INT2ASCII(check >> 4);
		g_atInstruction[2 + g_atParameterLength + 1] = INT2ASCII(check & 0x0f);
		g_atInstruction[2 + g_atParameterLength + 2] = chAnd;				// repeat flag

		memcpy(&g_atInstruction[2 + g_atParameterLength + 3], &g_atInstruction[1], g_atParameterLength + 1 + 2);

		g_atInstruction[2 + (g_atParameterLength + 1 + 2) * 2] = chSharp;		// end flag
		g_atInstruction[2 + (g_atParameterLength + 1 + 2) * 2 + 1] = 0x30;		// add 0 to even number
		g_atInstructionLength = 2 + (g_atParameterLength + 1 + 2) * 2 + 2;
	}
}

CDialogDlg::CDialogDlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_DIALOG_DIALOG, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_selectedUSBDevice = NULL;
	m_strEndPointEnumerate0x02 = _T("");
	m_strEndPointEnumerate0x04 = _T("");
	m_strEndPointEnumerate0x86 = _T("");
	m_strEndPointEnumerate0x88 = _T("");
	m_bButtonADCSampleClicked = FALSE;
	m_bButtonImpedanceClicked = FALSE;
	m_uDlNum = 0;
}

CDialogDlg::~CDialogDlg()
{
	if (m_selectedUSBDevice)
	{
		if (m_selectedUSBDevice->IsOpen()) m_selectedUSBDevice->Close();
		delete m_selectedUSBDevice;
	}
}

void CDialogDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_DEVICES, m_comboDevices);
	DDX_Control(pDX, IDC_BUTTON_VERSION, m_buttonVersion);
	DDX_Control(pDX, IDC_BUTTON_ADC_SAMPLE, m_buttonADCSample);
	DDX_Control(pDX, IDC_CUSTOM_SHOW, m_chartCtrl);
	DDX_Control(pDX, IDC_BUTTON_DL_NUM, m_buttonDlNum);
	DDX_Control(pDX, IDC_BUTTON_SAMPLE_FREQ, m_buttonSampleFreq);
	DDX_Control(pDX, IDC_BUTTON_SET_SAMPLE_FREQ, m_buttonSetSampleFreq);
	DDX_Control(pDX, IDC_EDIT_QUERY_RESULT, m_edtQueryResult);
	DDX_Control(pDX, IDC_EDIT_SAMPLE_FREQ, m_edtSampleFreq);
	DDX_Control(pDX, IDC_BUTTON_TRIG_LENGTH, m_buttonTrigLength);
	DDX_Control(pDX, IDC_BUTTON_AD_FREQ, m_buttonADFreq);
	DDX_Control(pDX, IDC_BUTTON_MAX_FREQ, m_buttonMaxFreq);
	DDX_Control(pDX, IDC_BUTTON_TRIGGER, m_buttonUSBTrig);
	DDX_Control(pDX, IDC_EDIT_TRIG_VALUE, m_edtTriggerValue);
	DDX_Control(pDX, IDC_EDIT_UART_TRIG, m_edtUartTrigValue);
	DDX_Control(pDX, IDC_BUTTON_IMPEDANCE, m_buttonImpedance);
	DDX_Control(pDX, IDC_EDIT_IMPEDANCE, m_edtImpedance);
	DDX_Control(pDX, IDC_COMBO_PORT_Nr, m_PortNr);
	DDX_Control(pDX, IDC_SendEdit, m_Send);
	DDX_Control(pDX, IDC_BUTTON_UART_TRIG, m_buttonUARTTrig);
}

BEGIN_MESSAGE_MAP(CDialogDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_CBN_SELCHANGE(IDC_COMBO_DEVICES, &CDialogDlg::OnCbnSelchangeComboDevices)
	ON_BN_CLICKED(IDC_BUTTON_VERSION, &CDialogDlg::OnBnClickedButtonVersion)
	ON_BN_CLICKED(IDC_BUTTON_ADC_SAMPLE, &CDialogDlg::OnBnClickedButtonAdcSample)
	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_BUTTON_DL_NUM, &CDialogDlg::OnBnClickedButtonDlNum)
	ON_BN_CLICKED(IDC_BUTTON_SAMPLE_FREQ, &CDialogDlg::OnBnClickedButtonSampleFreq)
	ON_BN_CLICKED(IDC_BUTTON_SET_SAMPLE_FREQ, &CDialogDlg::OnBnClickedButtonSetSampleFreq)
	ON_BN_CLICKED(IDC_BUTTON_TRIG_LENGTH, &CDialogDlg::OnBnClickedButtonTrigLength)
	ON_BN_CLICKED(IDC_BUTTON_AD_FREQ, &CDialogDlg::OnBnClickedButtonAdFreq)
	ON_BN_CLICKED(IDC_BUTTON_MAX_FREQ, &CDialogDlg::OnBnClickedButtonMaxFreq)
	ON_BN_CLICKED(IDC_BUTTON_TRIGGER, &CDialogDlg::OnBnClickedButtonTrigger)
	ON_BN_CLICKED(IDC_BUTTON_IMPEDANCE, &CDialogDlg::OnBnClickedButtonImpedance)
	ON_BN_CLICKED(IDC_BUTTON_MAX_INC, &CDialogDlg::OnBnClickedButtonMaxInc)
	ON_BN_CLICKED(IDC_BUTTON_MAX_DEC, &CDialogDlg::OnBnClickedButtonMaxDec)
	ON_BN_CLICKED(IDC_BUTTON_MIN_INC, &CDialogDlg::OnBnClickedButtonMinInc)
	ON_BN_CLICKED(IDC_BUTTON_MIN_DEC, &CDialogDlg::OnBnClickedButtonMinDec)
	ON_BN_CLICKED(IDC_BUTTON_SEND, &CDialogDlg::OnBnClickedButtonSend)
	ON_BN_CLICKED(IDC_BUTTON_UART_TRIG, &CDialogDlg::OnBnClickedButtonUartTrig)
END_MESSAGE_MAP()

// CDialogDlg 消息处理程序

BOOL CDialogDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != nullptr)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。  当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码
	m_selectedUSBDevice = new CCyUSBDevice(this->m_hWnd, CYUSBDRV_GUID, true);
	this->m_buttonADCSample.EnableWindow(FALSE);
	this->m_buttonUSBTrig.EnableWindow(FALSE);
	this->m_buttonUARTTrig.EnableWindow(FALSE);
	this->m_buttonVersion.EnableWindow(FALSE);
	this->m_buttonDlNum.EnableWindow(FALSE);
	this->m_buttonSampleFreq.EnableWindow(FALSE);
	this->m_buttonSetSampleFreq.EnableWindow(FALSE);
	this->m_buttonADFreq.EnableWindow(FALSE);
	this->m_buttonTrigLength.EnableWindow(FALSE);
	this->m_buttonMaxFreq.EnableWindow(FALSE);
	this->m_buttonImpedance.EnableWindow(FALSE);
	SurveyExistingDevices();
	EnumerateEndpointForTheSelectedDevice();

	UpdateData(FALSE);

	DataBuffInit();
	m_AxisMin = 32400;
	m_AxisMax = 34800;
	ChartCtrlInit();

	SurveyExistingComm();
	m_SerialPort.connectReadEvent(this);

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CDialogDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。  对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CDialogDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CDialogDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CDialogDlg::OnCbnSelchangeComboDevices()
{
	// TODO: 在此添加控件通知处理程序代码
}

LRESULT CDialogDlg::DefWindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
	// TODO: 在此添加专用代码和/或调用基类
	if (message == WM_DEVICECHANGE && wParam >= DBT_DEVICEARRIVAL)
	{
		SurveyExistingComm();

		PDEV_BROADCAST_HDR lpdb = (PDEV_BROADCAST_HDR)lParam;
		if (wParam == DBT_DEVICEARRIVAL && lpdb->dbch_devicetype == DBT_DEVTYP_DEVICEINTERFACE)
		{
			SurveyExistingDevices();
			if (m_pThread == NULL) EnumerateEndpointForTheSelectedDevice();
		}
		else if (wParam == DBT_DEVICEREMOVECOMPLETE && lpdb->dbch_devicetype == DBT_DEVTYP_DEVICEINTERFACE)
		{
			SurveyExistingDevices();

			if (m_pThread == NULL) EnumerateEndpointForTheSelectedDevice();
		}
		lpdb->dbch_devicetype;
		lpdb->dbch_size;
	}

	return CDialogEx::DefWindowProc(message, wParam, lParam);
}

bool CDialogDlg::SurveyExistingDevices()
{
	CCyUSBDevice* USBDevice;
	USBDevice = new CCyUSBDevice(this->m_hWnd, CYUSBDRV_GUID, true);
	CString strDevice("");
	int nCboIndex = -1;
	if (m_comboDevices.GetCount() > 0) m_comboDevices.GetWindowText(strDevice);

	m_comboDevices.ResetContent();

	if (USBDevice != NULL)
	{
		int nInsertionCount = 0;
		int nDeviceCount = USBDevice->DeviceCount();
		for (int nCount = 0; nCount < nDeviceCount; nCount++)
		{
			CString strDeviceData;
			USBDevice->Open(nCount);
			strDeviceData.Format("(0x%04X - 0x%04X) %s", USBDevice->VendorID, USBDevice->ProductID, CString(USBDevice->FriendlyName));
			m_comboDevices.InsertString(nInsertionCount++, strDeviceData);
			if (nCboIndex == -1 && strDevice.IsEmpty() == FALSE && strDevice == strDeviceData)
				nCboIndex = nCount;

			USBDevice->Close();
		}
		delete USBDevice;
		if (m_comboDevices.GetCount() >= 1)
		{
			if (nCboIndex != -1) m_comboDevices.SetCurSel(nCboIndex);
			else m_comboDevices.SetCurSel(0);
		}
		SetFocus();
	}
	else return FALSE;

	return TRUE;
}

bool CDialogDlg::EnumerateEndpointForTheSelectedDevice()
{
	int nDeviceIndex = 0;

	// Is there any FX device connected to system?
	if ((nDeviceIndex = m_comboDevices.GetCurSel()) == -1 || m_selectedUSBDevice == NULL)
	{
		this->m_buttonADCSample.EnableWindow(FALSE);
		this->m_buttonUSBTrig.EnableWindow(FALSE);
		this->m_buttonUARTTrig.EnableWindow(FALSE);
		this->m_buttonVersion.EnableWindow(FALSE);
		this->m_buttonDlNum.EnableWindow(FALSE);
		this->m_buttonSampleFreq.EnableWindow(FALSE);
		this->m_buttonSetSampleFreq.EnableWindow(FALSE);
		this->m_buttonADFreq.EnableWindow(FALSE);
		this->m_buttonTrigLength.EnableWindow(FALSE);
		this->m_buttonMaxFreq.EnableWindow(FALSE);
		this->m_buttonImpedance.EnableWindow(FALSE);

		m_buttonADCSample.SetWindowText("正式启动");

		return FALSE;
	}

	// There are devices connected in the system.       
	m_selectedUSBDevice->Open(nDeviceIndex);
	int interfaces = this->m_selectedUSBDevice->AltIntfcCount() + 1;

	for (int nDeviceInterfaces = 0; nDeviceInterfaces < interfaces; nDeviceInterfaces++)
	{
		m_selectedUSBDevice->SetAltIntfc(nDeviceInterfaces);
		int eptCnt = m_selectedUSBDevice->EndPointCount();

		// Fill the EndPointsBox
		for (int endPoint = 1; endPoint < eptCnt; endPoint++)
		{
			CCyUSBEndPoint* ept = m_selectedUSBDevice->EndPoints[endPoint];

			// INTR, BULK and ISO endpoints are supported.
			if (ept->Attributes == 2)
			{
				CString strData(""), strTemp;

				strData += ((ept->Attributes == 1) ? "ISOC " : ((ept->Attributes == 2) ? "BULK " : "INTR "));
				strData += (ept->bIn ? "IN, " : "OUT, ");
				//strTemp.Format("%d  Bytes,", ept->MaxPktSize);
				//strData += strTemp;
				//
				//if(m_selectedUSBDevice->BcdUSB == USB30)
				//{
				//    strTemp.Format("%d  MaxBurst,", ept->ssmaxburst);
				//    strData += strTemp;
				//}

				strTemp.Format("AltInt - %d and EpAddr - 0x%02X", nDeviceInterfaces, ept->Address);
				strData += strTemp;

				if (endPoint == 1)
					m_strEndPointEnumerate0x02 = strData;
				if (endPoint == 2)
					m_strEndPointEnumerate0x04 = strData;
				if (endPoint == 3)
					m_strEndPointEnumerate0x86 = strData;
				if (endPoint == 4)
					m_strEndPointEnumerate0x88 = strData;
			}
		}
	}

	this->m_buttonADCSample.EnableWindow(TRUE);
	this->m_buttonUSBTrig.EnableWindow(FALSE);
	this->m_buttonUARTTrig.EnableWindow(FALSE);
	this->m_buttonVersion.EnableWindow(TRUE);
	this->m_buttonDlNum.EnableWindow(TRUE);
	this->m_buttonSampleFreq.EnableWindow(TRUE);
	this->m_buttonSetSampleFreq.EnableWindow(TRUE);
	this->m_buttonADFreq.EnableWindow(TRUE);
	this->m_buttonTrigLength.EnableWindow(TRUE);
	this->m_buttonMaxFreq.EnableWindow(TRUE);
	this->m_buttonImpedance.EnableWindow(TRUE);

	return TRUE;
}

void CDialogDlg::OnBnClickedButtonVersion()
{
	DoQuery(15);
}

void CDialogDlg::ConfigADCSamplingRate(UINT samplingRate)
{
	g_samplingRate = samplingRate;

	CString strOutData = m_strEndPointEnumerate0x02;
	TCHAR* pEnd;
	BYTE outEpAddress = 0x0;

	// Extract the endpoint addresses........
	strOutData = strOutData.Right(4);

	//outEpAddress = (BYTE)wcstoul(strOutData.GetBuffer(0), &pEnd, 16);
	outEpAddress = strtol(strOutData, &pEnd, 16);
	CCyUSBEndPoint* epBulkOut = m_selectedUSBDevice->EndPointOf(outEpAddress);

	if (epBulkOut == NULL) return;

	//
	// Get the max packet size (USB Frame Size).
	// For bulk burst transfer, this size represent bulk burst size.
	// Transfer size is now multiple USB frames defined by PACKETS_PER_TRANSFER
	//
	UCHAR QUEUE_SIZE = 1;
	UCHAR PACKETS_PER_TRANSFER = 1;
	long totalOutTransferSize = epBulkOut->MaxPktSize * PACKETS_PER_TRANSFER;
	epBulkOut->SetXferSize(totalOutTransferSize);

	OVERLAPPED  outOvLap;
	UCHAR* bufferOutput = new UCHAR[totalOutTransferSize];
	outOvLap.hEvent = CreateEvent(NULL, false, false, NULL);

	BuildAtParameterSampleRate(samplingRate);
	BuildAtInstruction('Z');

	for (int nCount = 0; nCount < g_atInstructionLength; nCount++)
	{
		bufferOutput[nCount] = g_atInstruction[nCount];
	}

	epBulkOut->TimeOut = TIMEOUT_PER_TRANSFER_MILLI_SEC;

	// Mark the start time
	/*SYSTEMTIME objStartTime;
	GetSystemTime(&objStartTime);*/

	epBulkOut->XferData(bufferOutput, g_atInstructionLength);

	// Bail out......
	delete[] bufferOutput;
	CloseHandle(outOvLap.hEvent);
}

void CDialogDlg::StartAdcSample()
{
	CString strOutData = m_strEndPointEnumerate0x02;
	TCHAR* pEnd;
	BYTE outEpAddress = 0x0;

	// Extract the endpoint addresses........
	strOutData = strOutData.Right(4);

	//outEpAddress = (BYTE)wcstoul(strOutData.GetBuffer(0), &pEnd, 16);
	outEpAddress = strtol(strOutData, &pEnd, 16);
	CCyUSBEndPoint* epBulkOut = m_selectedUSBDevice->EndPointOf(outEpAddress);

	if (epBulkOut == NULL) return;

	//
	// Get the max packet size (USB Frame Size).
	// For bulk burst transfer, this size represent bulk burst size.
	// Transfer size is now multiple USB frames defined by PACKETS_PER_TRANSFER
	//
	UCHAR QUEUE_SIZE = 1;
	UCHAR PACKETS_PER_TRANSFER = 1;
	long totalOutTransferSize = epBulkOut->MaxPktSize * PACKETS_PER_TRANSFER;
	epBulkOut->SetXferSize(totalOutTransferSize);

	OVERLAPPED  outOvLap;
	UCHAR* bufferOutput = new UCHAR[totalOutTransferSize];
	outOvLap.hEvent = CreateEvent(NULL, false, false, NULL);

	BuildAtParameterSampleRateEx();
	BuildAtInstruction('K');

	for (int nCount = 0; nCount < g_atInstructionLength; nCount++)
	{
		bufferOutput[nCount] = g_atInstruction[nCount];
	}

	epBulkOut->TimeOut = TIMEOUT_PER_TRANSFER_MILLI_SEC;

	// Mark the start time
	/*SYSTEMTIME objStartTime;
	GetSystemTime(&objStartTime);*/

	epBulkOut->XferData(bufferOutput, g_atInstructionLength);

	// Bail out......
	delete[] bufferOutput;
	CloseHandle(outOvLap.hEvent);
}

void CDialogDlg::StopAdcSample()
{
	g_frameCheakStart = FALSE;

	CString strOutData = m_strEndPointEnumerate0x02;
	TCHAR* pEnd;
	BYTE outEpAddress = 0x0;

	// Extract the endpoint addresses........
	strOutData = strOutData.Right(4);

	//outEpAddress = (BYTE)wcstoul(strOutData.GetBuffer(0), &pEnd, 16);
	outEpAddress = strtol(strOutData, &pEnd, 16);
	CCyUSBEndPoint* epBulkOut = m_selectedUSBDevice->EndPointOf(outEpAddress);

	if (epBulkOut == NULL) return;

	//
	// Get the max packet size (USB Frame Size).
	// For bulk burst transfer, this size represent bulk burst size.
	// Transfer size is now multiple USB frames defined by PACKETS_PER_TRANSFER
	//
	UCHAR QUEUE_SIZE = 1;
	UCHAR PACKETS_PER_TRANSFER = 1;
	long totalOutTransferSize = epBulkOut->MaxPktSize * PACKETS_PER_TRANSFER;
	epBulkOut->SetXferSize(totalOutTransferSize);

	OVERLAPPED  outOvLap;
	UCHAR* bufferOutput = new UCHAR[totalOutTransferSize];
	outOvLap.hEvent = CreateEvent(NULL, false, false, NULL);

	BuildAtParameterStop();
	BuildAtInstruction('M');

	for (int nCount = 0; nCount < g_atInstructionLength; nCount++)
	{
		bufferOutput[nCount] = g_atInstruction[nCount];
	}

	epBulkOut->TimeOut = TIMEOUT_PER_TRANSFER_MILLI_SEC;

	// Mark the start time
	/*SYSTEMTIME objStartTime;
	GetSystemTime(&objStartTime);*/

	epBulkOut->XferData(bufferOutput, g_atInstructionLength);

	// Bail out......
	delete[] bufferOutput;
	CloseHandle(outOvLap.hEvent);
}

void CDialogDlg::SendTriggerValue(UCHAR value)
{
	CString strOutData = m_strEndPointEnumerate0x02;
	TCHAR* pEnd;
	BYTE outEpAddress = 0x0;

	// Extract the endpoint addresses........
	strOutData = strOutData.Right(4);

	//outEpAddress = (BYTE)wcstoul(strOutData.GetBuffer(0), &pEnd, 16);
	outEpAddress = strtol(strOutData, &pEnd, 16);
	CCyUSBEndPoint* epBulkOut = m_selectedUSBDevice->EndPointOf(outEpAddress);

	if (epBulkOut == NULL) return;

	//
	// Get the max packet size (USB Frame Size).
	// For bulk burst transfer, this size represent bulk burst size.
	// Transfer size is now multiple USB frames defined by PACKETS_PER_TRANSFER
	//
	UCHAR QUEUE_SIZE = 1;
	UCHAR PACKETS_PER_TRANSFER = 1;
	long totalOutTransferSize = epBulkOut->MaxPktSize * PACKETS_PER_TRANSFER;
	epBulkOut->SetXferSize(totalOutTransferSize);

	OVERLAPPED  outOvLap;
	UCHAR* bufferOutput = new UCHAR[totalOutTransferSize];
	outOvLap.hEvent = CreateEvent(NULL, false, false, NULL);

	BuildAtParameterTriggerValue(value);
	BuildAtInstruction('Z');

	for (int nCount = 0; nCount < g_atInstructionLength; nCount++)
	{
		bufferOutput[nCount] = g_atInstruction[nCount];
	}

	epBulkOut->TimeOut = TIMEOUT_PER_TRANSFER_MILLI_SEC;

	// Mark the start time
	/*SYSTEMTIME objStartTime;
	GetSystemTime(&objStartTime);*/

	epBulkOut->XferData(bufferOutput, g_atInstructionLength);

	// Bail out......
	delete[] bufferOutput;
	CloseHandle(outOvLap.hEvent);
}

void CDialogDlg::SendUartTrigValue(UCHAR value)
{
	BuildAtParameterUartTrig(value);
	BuildAtInstruction('T');

	m_SerialPort.writeData(g_atInstruction, g_atInstructionLength);
}

void CDialogDlg::SendImpedanceInstruction(UINT dlNum)
{
	CString strOutData = m_strEndPointEnumerate0x02;
	TCHAR* pEnd;
	BYTE outEpAddress = 0x0;

	// Extract the endpoint addresses........
	strOutData = strOutData.Right(4);

	//outEpAddress = (BYTE)wcstoul(strOutData.GetBuffer(0), &pEnd, 16);
	outEpAddress = strtol(strOutData, &pEnd, 16);
	CCyUSBEndPoint* epBulkOut = m_selectedUSBDevice->EndPointOf(outEpAddress);

	if (epBulkOut == NULL) return;

	//
	// Get the max packet size (USB Frame Size).
	// For bulk burst transfer, this size represent bulk burst size.
	// Transfer size is now multiple USB frames defined by PACKETS_PER_TRANSFER
	//
	UCHAR QUEUE_SIZE = 1;
	UCHAR PACKETS_PER_TRANSFER = 1;
	long totalOutTransferSize = epBulkOut->MaxPktSize * PACKETS_PER_TRANSFER;
	epBulkOut->SetXferSize(totalOutTransferSize);

	OVERLAPPED  outOvLap;
	UCHAR* bufferOutput = new UCHAR[totalOutTransferSize];
	outOvLap.hEvent = CreateEvent(NULL, false, false, NULL);

	BuildAtParameterDlNum(dlNum);
	BuildAtInstruction('Z');

	for (int nCount = 0; nCount < g_atInstructionLength; nCount++)
	{
		bufferOutput[nCount] = g_atInstruction[nCount];
	}

	epBulkOut->TimeOut = TIMEOUT_PER_TRANSFER_MILLI_SEC;

	// Mark the start time
	/*SYSTEMTIME objStartTime;
	GetSystemTime(&objStartTime);*/

	epBulkOut->XferData(bufferOutput, g_atInstructionLength);

	// Bail out......
	delete[] bufferOutput;
	CloseHandle(outOvLap.hEvent);
}

DWORD CDialogDlg::ClearUSBFIFO()
{
	CString strINData = m_strEndPointEnumerate0x86;
	TCHAR* pEnd;
	BYTE inEpAddress = 0x0;

	// Extract the endpoint addresses........
	strINData = strINData.Right(4);

	//inEpAddress = (BYTE)wcstoul(strINData.GetBuffer(0), &pEnd, 16);
	inEpAddress = strtol(strINData, &pEnd, 16);
	CCyUSBEndPoint* epBulkIn = m_selectedUSBDevice->EndPointOf(inEpAddress);

	if (epBulkIn == NULL) return -1;

	//
	// Get the max packet size (USB Frame Size).
	// For bulk burst transfer, this size represent bulk burst size.
	// Transfer size is now multiple USB frames defined by PACKETS_PER_TRANSFER
	//
	UCHAR QUEUE_SIZE = 16;
	//UCHAR PACKETS_PER_TRANSFER = 2;
	long totalTransferSize = epBulkIn->MaxPktSize * 2;
	epBulkIn->SetXferSize(totalTransferSize);

	PUCHAR* buffersInput = new PUCHAR[QUEUE_SIZE];
	PUCHAR* contextsInput = new PUCHAR[QUEUE_SIZE];
	OVERLAPPED		inOvLap[MAX_QUEUE_SZ];

	// Allocate all the buffers for the queues
	for (int nCount = 0; nCount < QUEUE_SIZE; nCount++)
	{
		buffersInput[nCount] = new UCHAR[totalTransferSize];
		inOvLap[nCount].hEvent = CreateEvent(NULL, false, false, NULL);

		memset(buffersInput[nCount], 0xEF, totalTransferSize);
	}

	// Queue-up the first batch of transfer requests
	for (int nCount = 0; nCount < QUEUE_SIZE; nCount++)
	{
		////////////////////BeginDataXFer will kick start the IN transactions.................
		contextsInput[nCount] = epBulkIn->BeginDataXfer(buffersInput[nCount], totalTransferSize, &inOvLap[nCount]);
		if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
		{

			if (epBulkIn->UsbdStatus == USBD_STATUS_ENDPOINT_HALTED)
			{
				epBulkIn->Reset();
				epBulkIn->Abort();
				Sleep(50);
				contextsInput[nCount] = epBulkIn->BeginDataXfer(buffersInput[nCount], totalTransferSize, &inOvLap[nCount]);

			}
			if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
			{
				// BeginDataXfer failed
				// Handle the error now.
				epBulkIn->Abort();
				for (int j = 0; j < QUEUE_SIZE; j++)
				{
					CloseHandle(inOvLap[j].hEvent);
					delete[] buffersInput[j];
				}

				// Bail out......
				delete[]contextsInput;
				delete[] buffersInput;
				CString strMsg;
				strMsg.Format("BeginDataXfer Failed with (NT Status = 0x%X and USBD Status = 0x%X). Bailing out...", epBulkIn->NtStatus, epBulkIn->UsbdStatus);
				AfxMessageBox(strMsg);
				return -2;
			}
		}
	}

	long nCount = 0;

	long readLength = totalTransferSize;

	//////////Wait till the transfer completion..///////////////////////////
	if (!epBulkIn->WaitForXfer(&inOvLap[nCount], TIMEOUT_PER_TRANSFER_MILLI_SEC))
	{
		//epBulkIn->Abort();
		//if (epBulkIn->LastError == ERROR_IO_PENDING)
		//	WaitForSingleObject(inOvLap[nCount].hEvent, TIMEOUT_PER_TRANSFER_MILLI_SEC);

		//epBulkIn->Reset();
		//Sleep(50);
		m_selectedUSBDevice->Reset();
		Sleep(TIMEOUT_PER_TRANSFER_MILLI_SEC);
		return -2;
	}

	////////////Read the trasnferred data from the device///////////////////////////////////////
	epBulkIn->FinishDataXfer(buffersInput[nCount], readLength, &inOvLap[nCount], contextsInput[nCount]);

	// Re-submit this queue element to keep the queue full
	contextsInput[nCount] = epBulkIn->BeginDataXfer(buffersInput[nCount], totalTransferSize, &inOvLap[nCount]);
	if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
	{
		// BeginDataXfer failed............
		// Time to bail out now............
		epBulkIn->Abort();
		for (int j = 0; j < QUEUE_SIZE; j++)
		{
			CloseHandle(inOvLap[j].hEvent);
			delete[] buffersInput[j];
		}
		delete[]contextsInput;

		CString strMsg;
		strMsg.Format("BeginDataXfer Failed during buffer re-cycle (NT Status = 0x%X and USBD Status = 0x%X). Bailing out...", epBulkIn->NtStatus, epBulkIn->UsbdStatus);
		AfxMessageBox(strMsg);
		return -3;
	}
	if (++nCount >= QUEUE_SIZE)
	{
		nCount = 0;
	}

	epBulkIn->Abort();
	for (int j = 0; j < QUEUE_SIZE; j++)
	{
		CloseHandle(inOvLap[j].hEvent);
		delete[] buffersInput[j];
		delete[] contextsInput[j];
	}

	// Bail out......
	delete[]contextsInput;
	delete[] buffersInput;

	return 0;
}

void CDialogDlg::OnBnClickedButtonAdcSample()
{
	char ch1[10];
	GetDlgItem(IDC_EDIT_IMPEDANCE)->GetWindowText(ch1, 10);
	m_uDlNum = atoi(ch1);
	if ((m_uDlNum < 1) || (m_uDlNum > 144))
	{
		AfxMessageBox(_T("请确认输入了正确的导联号！！！"));
		return;
	}
	g_daoLianIndex = 16 + 4 * (m_uDlNum - 1);

	if (m_bButtonImpedanceClicked)
	{
		AfxMessageBox(_T("请先关闭阻抗检测！！！"));
		return;
	}

	if (m_bButtonADCSampleClicked == FALSE)
	{
		m_bButtonADCSampleClicked = TRUE;

		m_buttonADCSample.SetWindowText("停止");
		m_buttonUSBTrig.EnableWindow(TRUE);
		m_buttonUARTTrig.EnableWindow(TRUE);

		//ConfigADCSamplingRate(24000);
		StartAdcSample();

		m_pThread = AfxBeginThread((AFX_THREADPROC)PerformADCSampling, (LPVOID)this);

		SetTimer(IDTIMER1, 100, NULL);
	}
	else
	{
		m_bButtonADCSampleClicked = FALSE;
		g_bKInstructionSend = FALSE;

		m_buttonADCSample.SetWindowText("正式启动");
		m_buttonUSBTrig.EnableWindow(FALSE);
		m_buttonUARTTrig.EnableWindow(FALSE);

		WaitForSingleObject(m_pThread->m_hThread, 100);
		m_pThread = NULL;

		StopAdcSample();

		KillTimer(IDTIMER1);

		ClearUSBFIFO();
	}
}

DWORD WINAPI CDialogDlg::PerformADCSampling(LPVOID lParam)
{
	CDialogDlg* pThis = (CDialogDlg*)lParam;

	CString strINData = pThis->m_strEndPointEnumerate0x86;
	TCHAR* pEnd;
	BYTE inEpAddress = 0x0;

	// Extract the endpoint addresses........
	strINData = strINData.Right(4);

	//inEpAddress = (BYTE)wcstoul(strINData.GetBuffer(0), &pEnd, 16);
	inEpAddress = strtol(strINData, &pEnd, 16);
	CCyUSBEndPoint* epBulkIn = pThis->m_selectedUSBDevice->EndPointOf(inEpAddress);

	if (epBulkIn == NULL) return -1;

	//
	// Get the max packet size (USB Frame Size).
	// For bulk burst transfer, this size represent bulk burst size.
	// Transfer size is now multiple USB frames defined by PACKETS_PER_TRANSFER
	//
	UCHAR QUEUE_SIZE = 16;
	//UCHAR PACKETS_PER_TRANSFER = 2;
	long totalTransferSize = epBulkIn->MaxPktSize * 2;
	epBulkIn->SetXferSize(totalTransferSize);

	PUCHAR* buffersInput = new PUCHAR[QUEUE_SIZE];
	PUCHAR* contextsInput = new PUCHAR[QUEUE_SIZE];
	OVERLAPPED		inOvLap[MAX_QUEUE_SZ];

	long nCounter = 0;

	while (pThis->m_bButtonADCSampleClicked == TRUE)
	{
		nCounter = nCounter + 1;
		CString strMsg1;
		strMsg1.Format("%d", nCounter);
		pThis->m_edtTriggerValue.SetWindowText(strMsg1);

		// Allocate all the buffers for the queues
		for (int nCount = 0; nCount < QUEUE_SIZE; nCount++)
		{
			buffersInput[nCount] = new UCHAR[totalTransferSize];
			inOvLap[nCount].hEvent = CreateEvent(NULL, false, false, NULL);

			memset(buffersInput[nCount], 0xEF, totalTransferSize);
		}

		// Queue-up the first batch of transfer requests
		for (int nCount = 0; nCount < QUEUE_SIZE; nCount++)
		{
			////////////////////BeginDataXFer will kick start the IN transactions.................
			contextsInput[nCount] = epBulkIn->BeginDataXfer(buffersInput[nCount], totalTransferSize, &inOvLap[nCount]);
			if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
			{

				if (epBulkIn->UsbdStatus == USBD_STATUS_ENDPOINT_HALTED)
				{
					epBulkIn->Reset();
					epBulkIn->Abort();
					Sleep(50);
					contextsInput[nCount] = epBulkIn->BeginDataXfer(buffersInput[nCount], totalTransferSize, &inOvLap[nCount]);

				}
				if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
				{
					// BeginDataXfer failed
					// Handle the error now.
					epBulkIn->Abort();
					for (int j = 0; j < QUEUE_SIZE; j++)
					{
						CloseHandle(inOvLap[j].hEvent);
						delete[] buffersInput[j];
					}

					// Bail out......
					delete[]contextsInput;
					delete[] buffersInput;
					CString strMsg;
					strMsg.Format("BeginDataXfer Failed with (NT Status = 0x%X and USBD Status = 0x%X). Bailing out...", epBulkIn->NtStatus, epBulkIn->UsbdStatus);
					AfxMessageBox(strMsg);
					return -2;
				}
			}
		}

		// Mark the start time
		/*SYSTEMTIME objStartTime;
		GetSystemTime(&objStartTime);*/

		long nCount = 0;
		//FILE* fp = NULL;
		while (pThis->m_bButtonADCSampleClicked == TRUE)
		{
			//if ((fp == NULL) && (pThis->m_bButtonADCSampleClicked == TRUE))
			//{
			//	fp = fopen("../samples/data.txt", "w");
			//}

			long readLength = totalTransferSize;

			//////////Wait till the transfer completion..///////////////////////////
			if (!epBulkIn->WaitForXfer(&inOvLap[nCount], TIMEOUT_PER_TRANSFER_MILLI_SEC))
			{
				//epBulkIn->Abort();
				//if (epBulkIn->LastError == ERROR_IO_PENDING)
				//	WaitForSingleObject(inOvLap[nCount].hEvent, TIMEOUT_PER_TRANSFER_MILLI_SEC);

				//epBulkIn->Reset();
				//Sleep(50);
				pThis->m_selectedUSBDevice->Reset();
				Sleep(TIMEOUT_PER_TRANSFER_MILLI_SEC);
				break;
			}

			////////////Read the trasnferred data from the device///////////////////////////////////////
			epBulkIn->FinishDataXfer(buffersInput[nCount], readLength, &inOvLap[nCount], contextsInput[nCount]);

			//for (int mCount = 0; mCount < readLength; mCount++)
			//{
			//	fprintf(fp, "%02X", buffersInput[nCount][mCount]);

			//	if (g_saveIndex + 1 == DATA_PAGE_LENGTH)
			//	{
			//		fprintf(fp, "\r");
			//	}
			//	else
			//	{
			//		fprintf(fp, "  ");
			//	}
			//	
			//	g_saveIndex = (g_saveIndex + 1) % DATA_PAGE_LENGTH;
			//}

			int frameNumber = 0;
			frameNumber += buffersInput[nCount][4] << 24;
			frameNumber += buffersInput[nCount][5] << 16;
			frameNumber += buffersInput[nCount][6] << 8;
			frameNumber += buffersInput[nCount][7];

			if ((frameNumber == 0) && (!g_frameCheakStart))
			{
				g_frameCheakStart = TRUE;
				g_frameNumber = 32767;
			}

			if (((32768 + frameNumber - g_frameNumber) % 32768 != 1) && g_frameCheakStart)
			{
				CString strFrameNumberError;
				strFrameNumberError.Format("g_frameNumber not continuous: %d - %d!!", g_frameNumber, frameNumber);
				pThis->m_edtQueryResult.SetWindowText(strFrameNumberError);
			}

			g_frameNumber = frameNumber;

			if ((buffersInput[nCount][0] == 0xAA)
				&& (buffersInput[nCount][1] == 0x00)
				&& (buffersInput[nCount][2] == 0x00)
				&& ((buffersInput[nCount][3] == g_triggerValue) || (buffersInput[nCount][3] == g_uartTrigValue))
				&& ((g_bButtonUSBTrigClicked == TRUE) || (g_bButtonUARTTrigClicked == TRUE)))
			{
				for (int mCount = 0; mCount < readLength; mCount++)
				{
					g_buffersTrigResult[mCount] = buffersInput[nCount][mCount];
				}

				g_bButtonUSBTrigClicked = FALSE;
				g_bButtonUARTTrigClicked = FALSE;
			}

			g_yBuff[g_writeIndex] = buffersInput[nCount][g_daoLianIndex] << 8;
			g_yBuff[g_writeIndex] += buffersInput[nCount][g_daoLianIndex + 1];

			g_writeIndex = (g_writeIndex + 1) % DATA_SHOW_LENGTH;

			//////////BytesXFerred is need for current data rate calculation.
			///////// Refer to CalculateTransferSpeed function for the exact
			///////// calculation.............................
			//if (BytesXferred < 0) // Rollover - reset counters
			//{
			//    BytesXferred = 0;
			//    GetSystemTime(&objStartTime);
			//}


			// Re-submit this queue element to keep the queue full
			contextsInput[nCount] = epBulkIn->BeginDataXfer(buffersInput[nCount], totalTransferSize, &inOvLap[nCount]);
			if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
			{
				// BeginDataXfer failed............
				// Time to bail out now............
				epBulkIn->Abort();
				for (int j = 0; j < QUEUE_SIZE; j++)
				{
					CloseHandle(inOvLap[j].hEvent);
					delete[] buffersInput[j];
				}
				delete[]contextsInput;

				CString strMsg;
				strMsg.Format("BeginDataXfer Failed during buffer re-cycle (NT Status = 0x%X and USBD Status = 0x%X). Bailing out...", epBulkIn->NtStatus, epBulkIn->UsbdStatus);
				AfxMessageBox(strMsg);
				return -3;
			}
			if (++nCount >= QUEUE_SIZE)
			{
				nCount = 0;
				//if ((pThis->m_bButtonADCSampleClicked == FALSE) && (fp != NULL))
				//{
				//	fclose(fp);
				//	fp = NULL;
				//}
			}
		}
	}

	epBulkIn->Abort();
	for (int j = 0; j < QUEUE_SIZE; j++)
	{
		CloseHandle(inOvLap[j].hEvent);
		delete[] buffersInput[j];
		delete[] contextsInput[j];
	}

	// Bail out......
	delete[]contextsInput;
	delete[] buffersInput;

	return 0;
}

void CDialogDlg::OnTimer(UINT_PTR nIDEvent)
{
	switch (nIDEvent)
	{
	case IDTIMER1:
	{
		m_chartCtrl.EnableRefresh(FALSE);
		CChartLineSerie* pLineSerie;
		m_chartCtrl.RemoveAllSeries();
		pLineSerie = m_chartCtrl.CreateLineSerie();
		pLineSerie->SetSeriesOrdering(poNoOrdering);
		pLineSerie->AddPoints(g_xBuff, g_yBuff, DATA_SHOW_LENGTH);
		UpdateWindow();
		m_chartCtrl.EnableRefresh(TRUE);

		break;
	}
	case IDTIMER2:
	{
		DoQuery(47 + (m_uDlNum - 1) * 4);

		break;
	}
	default:
		break;
	}

	CDialogEx::OnTimer(nIDEvent);
}

// 显示点数据包初始化
void CDialogDlg::DataBuffInit()
{
	// TODO: 在此处添加实现代码.
	for (int i = 0; i < DATA_SHOW_LENGTH; i++)
	{
		g_xBuff[i] = i + 1;
	}
}

// 初始化画图界面窗口
void CDialogDlg::ChartCtrlInit()
{
	// TODO: 在此处添加实现代码.
	//手动创建显示窗口
	//CRect rect, rectChart;
	//GetDlgItem(IDC_CUSTOM_SHOW)->GetWindowRect(&rect);
	//ScreenToClient(rect);
	//rectChart = rect;
	//rectChart.top = rect.bottom + 3;
	//rectChart.bottom = rectChart.top + rect.Height();
	//m_ChartCtrl2.Create(this, rectChart, IDC_CUSTOM_SHOW2);
	//m_ChartCtrl2.ShowWindow(SW_SHOWNORMAL);
	///////////////////////显示主题/////////////////////////////
	m_chartCtrl.GetTitle()->RemoveAll();
	m_chartCtrl.GetTitle()->AddString(_T("波形"));
	///////////////////////创建坐标xy标识/////////////////////////////
	//m_ChartCtrl.GetBottomAxis()->GetLabel()->SetText(_T("强度"));
	//m_ChartCtrl.GetLeftAxis()->GetLabel()->SetText(_T("采样点"));
	///////////////////////创建坐标显示范围/////////////////////////////
	CChartAxis* pAxis = NULL;
	pAxis = m_chartCtrl.CreateStandardAxis(CChartCtrl::BottomAxis);
	pAxis->SetMinMax(1, DATA_SHOW_LENGTH);
	pAxis = m_chartCtrl.CreateStandardAxis(CChartCtrl::LeftAxis);
	pAxis->SetMinMax(m_AxisMin, m_AxisMax);
}

void CDialogDlg::DoQuery(UINT pos)
{
	CString strINData = m_strEndPointEnumerate0x88;
	CString strOutData = m_strEndPointEnumerate0x02;
	TCHAR* pEnd;
	BYTE inEpAddress = 0x0, outEpAddress = 0x0;

	// Extract the endpoint addresses........
	strINData = strINData.Right(4);
	strOutData = strOutData.Right(4);

	//inEpAddress = (BYTE)wcstoul(strINData.GetBuffer(0), &pEnd, 16);
	inEpAddress = strtol(strINData, &pEnd, 16);
	//outEpAddress = (BYTE)wcstoul(strOutData.GetBuffer(0), &pEnd, 16);
	outEpAddress = strtol(strOutData, &pEnd, 16);
	CCyUSBEndPoint* epBulkOut = m_selectedUSBDevice->EndPointOf(outEpAddress);
	CCyUSBEndPoint* epBulkIn = m_selectedUSBDevice->EndPointOf(inEpAddress);

	if (epBulkOut == NULL || epBulkIn == NULL) return;

	//
	// Get the max packet size (USB Frame Size).
	// For bulk burst transfer, this size represent bulk burst size.
	// Transfer size is now multiple USB frames defined by PACKETS_PER_TRANSFER
	//
	UCHAR QUEUE_SIZE = 1;
	//UCHAR PACKETS_PER_TRANSFER = 2;
	long totalTransferSize = epBulkIn->MaxPktSize * 2;
	epBulkIn->SetXferSize(totalTransferSize);

	long totalOutTransferSize = epBulkOut->MaxPktSize * 1;
	epBulkOut->SetXferSize(totalOutTransferSize);

	PUCHAR* buffersInput = new PUCHAR[QUEUE_SIZE];
	PUCHAR* contextsInput = new PUCHAR[QUEUE_SIZE];
	OVERLAPPED		inOvLap[MAX_QUEUE_SZ];

	// Allocate all the buffers for the queues
	for (int nCount = 0; nCount < QUEUE_SIZE; nCount++)
	{
		buffersInput[nCount] = new UCHAR[totalTransferSize];
		inOvLap[nCount].hEvent = CreateEvent(NULL, false, false, NULL);

		memset(buffersInput[nCount], 0xEF, totalTransferSize);
	}

	OVERLAPPED  outOvLap;
	UCHAR* bufferOutput = new UCHAR[totalOutTransferSize];
	outOvLap.hEvent = CreateEvent(NULL, false, false, NULL);

	BuildAtParameterQuery();
	BuildAtInstruction('R');

	for (int nCount = 0; nCount < g_atInstructionLength; nCount++)
	{
		bufferOutput[nCount] = g_atInstruction[nCount];
	}

	epBulkOut->TimeOut = TIMEOUT_PER_TRANSFER_MILLI_SEC;

	// Queue-up the first batch of transfer requests
	for (int nCount = 0; nCount < QUEUE_SIZE; nCount++)
	{
		////////////////////BeginDataXFer will kick start the IN transactions.................
		contextsInput[nCount] = epBulkIn->BeginDataXfer(buffersInput[nCount], totalTransferSize, &inOvLap[nCount]);
		if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
		{

			if (epBulkIn->UsbdStatus == USBD_STATUS_ENDPOINT_HALTED)
			{
				epBulkIn->Reset();
				epBulkIn->Abort();
				Sleep(50);
				contextsInput[nCount] = epBulkIn->BeginDataXfer(buffersInput[nCount], totalTransferSize, &inOvLap[nCount]);

			}
			if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
			{
				// BeginDataXfer failed
				// Handle the error now.
				epBulkIn->Abort();
				for (int j = 0; j < QUEUE_SIZE; j++)
				{
					CloseHandle(inOvLap[j].hEvent);
					delete[] buffersInput[j];
				}

				// Bail out......
				delete[]contextsInput;
				delete[] buffersInput;
				CString strMsg;
				strMsg.Format("BeginDataXfer Failed with (NT Status = 0x%X and USBD Status = 0x%X). Bailing out...", epBulkIn->NtStatus, epBulkIn->UsbdStatus);
				AfxMessageBox(strMsg);
				return;
			}
		}
	}

	// Mark the start time
	/*SYSTEMTIME objStartTime;
	GetSystemTime(&objStartTime);*/

	long nINCount = 0;
	while (nINCount < QUEUE_SIZE)
	{
		long readLength = totalTransferSize;

		epBulkOut->XferData(bufferOutput, g_atInstructionLength);

		//////////Wait till the transfer completion..///////////////////////////
		if (!epBulkIn->WaitForXfer(&inOvLap[nINCount], TIMEOUT_PER_TRANSFER_MILLI_SEC))
		{
			epBulkIn->Abort();
			if (epBulkIn->LastError == ERROR_IO_PENDING)
				WaitForSingleObject(inOvLap[nINCount].hEvent, TIMEOUT_PER_TRANSFER_MILLI_SEC);
		}

		////////////Read the trasnferred data from the device///////////////////////////////////////
		epBulkIn->FinishDataXfer(buffersInput[nINCount], readLength, &inOvLap[nINCount], contextsInput[nINCount]);

		CString strBytes(""), strTemp;
		for (int nCount = 0; nCount < readLength; nCount++)
		{
			if (nCount % 16 == 0)
			{
				strTemp.Format("%04X", nCount);
				strBytes += strTemp;
				if ((nCount - 1) == pos)
				{
					strBytes += "   \"";
				}
				else
				{
					strBytes += "    ";
				}
			}

			strTemp.Format("%02X", buffersInput[0][nCount]);
			strBytes += strTemp;

			if ((nCount + 1) % 16 == 0)
			{
				if (nCount == pos + 4)
				{
					strBytes += "\"\r\n";
				}
				else
				{
					strBytes += "\r\n";
				}
			}
			else
			{
				if (nCount == pos)
				{
					strBytes += " \"";
				}
				else if (nCount == pos + 4)
				{
					strBytes += "\" ";
				}
				else
				{
					strBytes += "  ";
				}
			}
		}
		m_edtQueryResult.SetWindowText(strBytes);

		//////////BytesXFerred is need for current data rate calculation.
		///////// Refer to CalculateTransferSpeed function for the exact
		///////// calculation.............................
		//if (BytesXferred < 0) // Rollover - reset counters
		//{
		//    BytesXferred = 0;
		//    GetSystemTime(&objStartTime);
		//}


		// Re-submit this queue element to keep the queue full
		contextsInput[nINCount] = epBulkIn->BeginDataXfer(buffersInput[nINCount], totalTransferSize, &inOvLap[nINCount]);
		if (epBulkIn->NtStatus || epBulkIn->UsbdStatus)
		{
			// BeginDataXfer failed............
			// Time to bail out now............
			epBulkIn->Abort();
			for (int j = 0; j < QUEUE_SIZE; j++)
			{
				CloseHandle(inOvLap[j].hEvent);
				delete[] buffersInput[j];
			}
			delete[]contextsInput;

			CString strMsg;
			strMsg.Format("BeginDataXfer Failed during buffer re-cycle (NT Status = 0x%X and USBD Status = 0x%X). Bailing out...", epBulkIn->NtStatus, epBulkIn->UsbdStatus);
			AfxMessageBox(strMsg);
			return;
		}
		++nINCount;
	}

	epBulkIn->Abort();
	for (int j = 0; j < QUEUE_SIZE; j++)
	{
		CloseHandle(inOvLap[j].hEvent);
		delete[] buffersInput[j];
		delete[] contextsInput[j];
	}

	// Bail out......
	delete[]contextsInput;
	delete[] buffersInput;
	delete[] bufferOutput;
	CloseHandle(outOvLap.hEvent);

	return;
}

void CDialogDlg::OnBnClickedButtonDlNum()
{
	DoQuery(19);
}

void CDialogDlg::OnBnClickedButtonSampleFreq()
{
	DoQuery(23);
}

void CDialogDlg::OnBnClickedButtonSetSampleFreq()
{
	UINT sampleFreq = 0x9C40;
	char ch1[10];
	GetDlgItem(IDC_EDIT_SAMPLE_FREQ)->GetWindowText(ch1, 10);
	sampleFreq = atoi(ch1);
	ConfigADCSamplingRate(sampleFreq);
}

void CDialogDlg::OnBnClickedButtonTrigLength()
{
	DoQuery(31);
}

void CDialogDlg::OnBnClickedButtonAdFreq()
{
	DoQuery(27);
}

void CDialogDlg::OnBnClickedButtonMaxFreq()
{
	DoQuery(39);
}

void CDialogDlg::OnBnClickedButtonTrigger()
{
	g_bButtonUSBTrigClicked = TRUE;

	char ch1[10];
	GetDlgItem(IDC_EDIT_TRIG_VALUE)->GetWindowText(ch1, 10);
	g_triggerValue = atoi(ch1);

	SendTriggerValue(g_triggerValue);

	while (g_bButtonUSBTrigClicked);

	CString strBytes(""), strTemp;
	for (int nCount = 0; nCount < DATA_PAGE_LENGTH; nCount++)
	{
		if (nCount % 16 == 0)
		{
			strTemp.Format("%04X", nCount);
			strBytes += strTemp;
			strBytes += "    ";
		}

		strTemp.Format("%02X", g_buffersTrigResult[nCount]);
		strBytes += strTemp;

		if ((nCount + 1) % 16 == 0)
		{
			strBytes += "\r\n";
		}
		else
		{
			strBytes += "  ";
		}
	}
	m_edtQueryResult.SetWindowText(strBytes);
}

void CDialogDlg::OnBnClickedButtonUartTrig()
{
	char portName[256] = { 0 };
	int SelParity;
	int SelDataBits;
	int SelStop;

	UpdateData(true);
	CString temp;
	m_PortNr.GetWindowText(temp);
#ifdef UNICODE
	strcpy_s(portName, 256, CW2A(temp.GetString()));
#else
	strcpy_s(portName, 256, temp.GetBuffer());
#endif	

	if ((!m_SerialPort.isOpen()) || (strcmp(m_SerialPort.getPortName(), temp) != 0)) ///没有打开串口
	{
		m_SerialPort.setReadIntervalTimeout(0);
		m_SerialPort.init(portName, itas109::BaudRate::BaudRate115200, itas109::Parity(ParityNone), itas109::DataBits(DataBits8), itas109::StopBits(StopOne));
		m_SerialPort.open();
	}

	g_bButtonUARTTrigClicked = TRUE;

	char ch1[10];
	GetDlgItem(IDC_EDIT_UART_TRIG)->GetWindowText(ch1, 10);
	g_uartTrigValue = atoi(ch1);

	SendUartTrigValue(g_uartTrigValue);

	while (g_bButtonUARTTrigClicked);

	CString strBytes(""), strTemp;
	for (int nCount = 0; nCount < DATA_PAGE_LENGTH; nCount++)
	{
		if (nCount % 16 == 0)
		{
			strTemp.Format("%04X", nCount);
			strBytes += strTemp;
			strBytes += "    ";
		}

		strTemp.Format("%02X", g_buffersTrigResult[nCount]);
		strBytes += strTemp;

		if ((nCount + 1) % 16 == 0)
		{
			strBytes += "\r\n";
		}
		else
		{
			strBytes += "  ";
		}
	}
	m_edtQueryResult.SetWindowText(strBytes);
}

void CDialogDlg::OnBnClickedButtonImpedance()
{
	char ch1[10];
	GetDlgItem(IDC_EDIT_IMPEDANCE)->GetWindowText(ch1, 10);
	m_uDlNum = atoi(ch1);
	if ((m_uDlNum < 1) || (m_uDlNum > 144))
	{
		AfxMessageBox(_T("请确认输入了正确的导联号！！！"));
		return;
	}
	g_daoLianIndex = 16 + 4 * (m_uDlNum - 1);

	if (m_bButtonADCSampleClicked)
	{
		AfxMessageBox(_T("请先关闭导联信号采集！！！"));
		return;
	}

	if (m_bButtonImpedanceClicked)
	{
		m_buttonImpedance.SetWindowText("阻抗检测");
		SendImpedanceInstruction(0);
		KillTimer(IDTIMER2);
		m_bButtonImpedanceClicked = FALSE;
	}
	else
	{
		m_buttonImpedance.SetWindowText("停止");
		SendImpedanceInstruction(m_uDlNum);
		SetTimer(IDTIMER2, 1000, NULL);
		m_bButtonImpedanceClicked = TRUE;
	}
}

void CDialogDlg::OnBnClickedButtonMaxInc()
{
	m_AxisMax = m_AxisMax + 100;

	m_chartCtrl.GetLeftAxis()->SetMinMax(m_AxisMin, m_AxisMax);
	m_chartCtrl.RefreshCtrl();
}

void CDialogDlg::OnBnClickedButtonMaxDec()
{
	m_AxisMax = m_AxisMax - 100;

	m_chartCtrl.GetLeftAxis()->SetMinMax(m_AxisMin, m_AxisMax);
	m_chartCtrl.RefreshCtrl();
}

void CDialogDlg::OnBnClickedButtonMinInc()
{
	m_AxisMin = m_AxisMin + 100;

	m_chartCtrl.GetLeftAxis()->SetMinMax(m_AxisMin, m_AxisMax);
	m_chartCtrl.RefreshCtrl();
}

void CDialogDlg::OnBnClickedButtonMinDec()
{
	m_AxisMin = m_AxisMin - 100;

	m_chartCtrl.GetLeftAxis()->SetMinMax(m_AxisMin, m_AxisMax);
	m_chartCtrl.RefreshCtrl();
}


void CDialogDlg::OnBnClickedButtonSend()
{
	GetDlgItem(IDC_SendEdit)->SetFocus();

	char portName[256] = { 0 };
	int SelParity;
	int SelDataBits;
	int SelStop;

	UpdateData(true);
	CString temp;
	m_PortNr.GetWindowText(temp);
#ifdef UNICODE
	strcpy_s(portName, 256, CW2A(temp.GetString()));
#else
	strcpy_s(portName, 256, temp.GetBuffer());
#endif	

	if ((!m_SerialPort.isOpen()) || (strcmp(m_SerialPort.getPortName(), temp) != 0))
	{
		m_SerialPort.setReadIntervalTimeout(0);
		m_SerialPort.init(portName, itas109::BaudRate::BaudRate115200, itas109::Parity(ParityNone), itas109::DataBits(DataBits8), itas109::StopBits(StopOne));
		m_SerialPort.open();
	}

	CString strInstruction;
	m_Send.GetWindowTextA(strInstruction);

	if (strcmp(strInstruction.Mid(0, 1), _T("@")) != 0)
	{
		return;
	}

	if (strcmp(strInstruction.Mid(1, 1), _T("W")) == 0)
	{
		BuildAtParameterUartWrite(strInstruction);
		BuildAtInstruction('W');

		m_SerialPort.writeData(g_atInstruction, g_atInstructionLength);
	}
	
	if (strcmp(strInstruction.Mid(1, 1), _T("R")) == 0)
	{
		BuildAtParameterUartRead();
		BuildAtInstruction('R');

		m_SerialPort.writeData(g_atInstruction, g_atInstructionLength);
	}
}

void CDialogDlg::onReadEvent(const char* portName, unsigned int readBufferLen)
{
	if (readBufferLen > 0)
	{
		char* data = new char[readBufferLen + 1]; // '\0'

		if (data)
		{
			int recLen = m_SerialPort.readData(data, readBufferLen);

			if (recLen > 0)
			{
				data[recLen] = '\0';

				CString str1(data);
				m_edtQueryResult.SetWindowTextA(str1);
			}

			delete[] data;
			data = NULL;
		}
	}
}


bool CDialogDlg::SurveyExistingComm()
{
	//获取串口号
	std::vector<SerialPortInfo> m_portsList = CSerialPortInfo::availablePortInfos();
	for (size_t i = 0; i < m_portsList.size(); i++)
	{
		CString m_portName = CString();
#ifdef UNICODE
		int iLength;
		const char* _char = m_portsList[i].portName;
		iLength = MultiByteToWideChar(CP_ACP, 0, _char, strlen(_char) + 1, NULL, 0);
		MultiByteToWideChar(CP_ACP, 0, _char, strlen(_char) + 1, m_regKeyValue, iLength);
#else
		m_portName = m_portsList[i].portName;
#endif
		m_PortNr.AddString(m_portName);
	}
	m_PortNr.SetCurSel(0);

	return true;
}


