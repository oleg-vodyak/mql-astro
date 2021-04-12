//+------------------------------------------------------------------+
//|                                                  TransitView.mq4 |
//|                                                   InvestmentDoge |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "InvestmentDoge"
#property link      "https://www.mql5.com"
#property version   "1.2"
#property strict
#property indicator_chart_window


#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
#include <Controls\ListView2.mqh>
#include <Controls\ComboBox.mqh>
#include <Controls\SpinEdit.mqh>
#include <Controls\RadioGroup.mqh>
#include <Controls\CheckGroup.mqh>

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//--- indents and gaps
#define INDENT_LEFT                         (141)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width)
#define INDENT_RIGHT                        (11)      // indent from right (with allowance for border width)
#define INDENT_BOTTOM                       (11)      // indent from bottom (with allowance for border width)
#define CONTROLS_GAP_X                      (10)      // gap by X coordinate
#define CONTROLS_GAP_Y                      (0)      // gap by Y coordinate
//--- for buttons
#define BUTTON_WIDTH                        (70)     // size by X coordinate
#define BUTTON_HEIGHT                       (20)      // size by Y coordinate
//--- for the indication area
#define EDIT_HEIGHT                         (130)      // size by Y coordinate
//+------------------------------------------------------------------+
#define COMBO_HEIGHT                         (20)      // size by Y coordinate
#define COMBO_WIDTH                         (70)      // size by Y coordinate
#define COMBO_LWIDTH                         (100)
#define COMBO_SMWIDTH                         (35)      // size by Y coordinate
#define EDIT_WIDTH                            (200)
//--- for group controls 
#define GROUP_WIDTH                         (150)     // size by X coordinate 
#define LIST_HEIGHT                         (179)     // size by Y coordinate 
#define RADIO_HEIGHT                        (56)      // size by Y coordinate 
#define CHECK_HEIGHT                        (93)      // size by Y coordinate 
#define InpEncodingType    (FILE_ANSI)

input int NumberOfPatterns=5;
input color AllureColor=clrOrange;
input color TransitColor=clrSpringGreen;
input color ExcelColor=clrOrchid;
string TransitFileName="Ephemerides.txt"; 
string NatalFileName="Table.txt";   // имя файла 
string UranusAllureFileName="uranus allur.txt";
input string UranusIngressionFileName="uranus ingr.txt";
string UranusTransitFileName="uranus.txt";
string UranusDirectionFileName="uranus DIR.txt";
string UranusProfectionFileName="uranus PRO.txt";
string UranusTretichFileName="uranus TRE.txt";
string UranusMinorFileName="uranus MIN.txt";
string ExcelFileName="ПН.txt";
string ExcelFileName2="Нефть.txt";
string FilterFileName="без фильтра.txt";

string FilterFileName2="без фильтра.txt";
input string DirectoryName="NEWallyr";   // имя директории 
input string DirectoryNameS="Saved";   // имя директории 
input string DirectoryNameN="NEWN";   // имя директории
input string DirectoryNameF="Saved";   // имя директории
bool ExcelImport=true;
input bool ExcelOnlyPP=false;
bool ALLURE_ANALYSYS=true;
input bool ShowHouses=true;
input bool OnlyFast=false;
input bool ShowMercury=false;
input bool ShowSun=false;
input bool ShowMoon=false;
input bool ShowVenus=false;
input bool ShowMars=false;
input bool ShowJupiter=true;
input bool ShowSaturn=true;
input bool ShowUranus=true;
input bool ShowNeptune=true;
input bool ShowPluto=true;
input bool AspectToMercury=false;
input bool AspectToSun=true;
input bool AspectToMoon=true;
input bool AspectToVenus=true;
input bool AspectToMars=true;
input bool AspectToJupiter=true;
input bool AspectToSaturn=true;
input bool AspectToUranus=true;
input bool AspectToNeptune=true;
input bool AspectToPluto=true;
double TrendDelta=0.005;
input bool UranusImport=true;
int curBurrsH1=iBars("Null",PERIOD_H1);
int curBurrsH4=iBars("Null",PERIOD_H4);
int curBurrsD1=iBars("Null",PERIOD_D1);
int globalcount=0;
   bool InitEnded=false;
   string labelarr[];
   int numlabel=0;
   int numobj=0;
   double sizeshift=0;
   string pcurr="Jupiter";
   double fstmult=1.1, sndmult=1.2;
  // double priceshift;
   
   int natal;
     string allyrfile[],neft[],usa[],gold[];
    double SU, L, ME, V, MA, J, SA, U, N, P;
    string planets[14]={"---", "Солнце", "Луна", "Меркурий", "Венера", "Марс", "Юпитер", "Сатурн", "Уран", "Нептун", "Плутон","Хирон", "Раху", "Кету"};
    string natals[13]={"H.1", "H.2", "H.3","H.4", "H.5","H.6", "H.7","H.8", "H.9","H.10", "H.11","H.12","Все"};
    string signsIngression[12]={"Овен", "Телец", "Близнецы", "Рак", "Лев", "Дева", "Весы", "Скорпион", "Стрелец", "Козерог", "Водолей", "Рыбы"};
    string colors[5]={"Красный","Синий","Желтый","Белый","Фиолетовый"};
    string aspects[6]={" 0", "60", "90", "120", "180", "Ингр."};
    string maps[4]={"Аллюр", "PN", "НЕФТЬ","Золото"};
    string readmaps[];
    string month[13]={"-","1","2","3","4","5","6","7","8","9","10","11","12"};
    string year[31]={"-","2030","2029","2028","2027","2026","2025","2024","2023","2022","2021","2020","2019","2018","2017","2016","2015","2014","2013","2012","2011","2010","2009","2008","2007","2006","2005","2004","2003","2002","2001"};
    string risuem[1]={"Раскраску"/*,"Данные","Д+Р"*/};
    double H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12;
    double housedegs[20]; 
     
    string curr[], currIng[], signIng[], currtrans[], currdir[], currprof[], currtret[], currmin[], currexc[];
    double degSU[], degL[], degME[], degV[], degMA[], degJ[], degSA[], degU[], degN[], degP[];
    double Pone[], Ptwo[]; datetime datearr[], dateIng[], datetrans[], datedir[], dateprof[], datetret[], datemin[];
    string Pname1[], Pname2[], PnameIng[], Ptrans1[], Ptrans2[], Pdir1[], Pdir2[], Pprof1[], Pprof2[], Ptret1[], Ptret2[], Pmin1[], Pmin2[];
    int asp[], asptrans[], aspdir[], aspprof[], asptret[], aspmin[],casestrans[],casesdir[],casesprof[],casestret[],casesmin[],casesexc[],casesIng[],casesasp[];
    double allureasp=0, allureorb=1;
    string excelobjnames[], excelstrings[], allureobjnames[], allureobjstrings[], transitobjnames[], transitobjstrings[];
    
    datetime prevdate=0;
    double prevprice=0;
    double pricedraw=0;
    
   datetime TimeCurrent;
   
    class TVpanel : public CAppDialog
  {
public:
   CEdit             m_edit;
   CEdit             m_edit2;
   CEdit             m_edit3;
   CButton           m_buttonOK;
   CButton           m_button1;                       // the button object
   CButton           m_button2;                       // the button object
   CButton           m_button3;                       // the fixed button object
   CButton           m_button4;    
   CButton           m_button5;  
   CListView2         m_list_view;      
     CComboBox         m_combo0[];
     CComboBox         m_combo00[];
     CComboBox         m_combo00p[];
     CComboBox         m_combo00n[];
     CComboBox         m_combo00g[];
   CComboBox         m_combo1[];
   CComboBox         m_combo2[]; 
   CComboBox         m_combo3[]; 
   CComboBox         m_combo3i[]; 
   CComboBox         m_combo4[];
   CComboBox         m_combo5[];
   CComboBox         m_combo6;
   CComboBox         m_combo7;
   CComboBox         m_combo8;
private:
   CComboBox         m_comboExc; 
   CComboBox         m_comboExc2;    
   CComboBox         m_comboTra; 
   CComboBox         m_comboFil;
   CComboBox         m_comboFil2;
   CLabel            m_label[]; 
   CLabel            m_label1; 
   CLabel            m_label2; 
   CLabel            m_label3;    
   CLabel            m_label4; 
   CLabel            m_label5;    
   CLabel            m_label6;   
   CLabel            m_label7;      
CLabel            m_label8;      
      CCheckGroup         m_check_group;                    // CCheckBox object 
            CCheckGroup         m_check_group1; 
            CCheckGroup         m_check_group11; 
            CCheckGroup         m_check_group2;
public:
                     TVpanel(void);
                    ~TVpanel(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   bool Save(const int file_handle);
   bool Load(const int file_handle);
protected:
   //--- create dependent controls
   //bool              CreateEdit(void);
   bool              CreateButtonOK(void);
   bool              CreateButton1(void);
   bool              CreateButton2(void);
   bool              CreateButton3(void);
//    bool              CreateButton4(void);
    bool              CreateButton5(void);
//   bool              CreateListView(void);
       bool              CreateCombobox0(int i);
       bool              CreateCombobox00(int i);
       bool              CreateCombobox00p(int i);
       bool              CreateCombobox00n(int i);
       bool              CreateCombobox00g(int i);
    bool              CreateCombobox1(int i);
    bool              CreateCombobox2(int i);
        bool              CreateCombobox3(int i);
         bool              CreateCombobox3i(int i);
         bool              CreateEdit(void);
         bool              CreateEdit2(void);
         bool              CreateEdit3(void);
//    bool              CreateCombobox4(int i);
//    bool              CreateCombobox5(int i);
    bool              CreateCombobox6();
    bool              CreateCombobox7();
//    bool             CreateCombobox8();

//   bool              CreateCheckGroup(void); 
//   bool              CreateCheckGroup1(void);      
//bool              CreateCheckGroup11(void);      
//   bool              CreateCheckGroup2(void);     
            bool              CreateLabel(int i);
          bool              CreateLabels();
//  bool              CreateComboboxExc();
//  bool              CreateComboboxExc2();  
//  bool              CreateComboboxTra();
  bool              CreateComboboxFilter();
//  bool              CreateComboboxFilter2();
   //--- internal event handlers
   virtual bool      OnResize(void);
   //--- handlers of the dependent controls events
   void              OnClickButton1(void);
   void              OnClickButton2(void);
   void              OnClickButtonOK(void);
      void              OnClickButton3(void);
      void              OnClickButton4(void);
   void              OnClickButton5(void);
   void             OnChangeComboboxExc(void);
   void             OnChangeComboboxExc2(void);   
      void             OnChangeComboboxTra(void);
      void           OnChangeComboboxFilter(void);
      void           OnChangeComboboxFilter2(void);
      void           OnChangeCheckGroup1(void);
      void           OnChangeCheckGroup11(void);
      void           OnChangeCheckGroup(void);
      void           OnChangeCheckGroup2(void);
   bool              OnDefault(const int id,const long &lparam,const double &dparam,const string &sparam);
  };
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(TVpanel) 
ON_EVENT(ON_CLICK,m_buttonOK,OnClickButtonOK)
ON_EVENT(ON_CLICK,m_button1,OnClickButton1)
ON_EVENT(ON_CLICK,m_button2,OnClickButton2)
ON_EVENT(ON_CLICK,m_button3,OnClickButton3)
ON_EVENT(ON_CLICK,m_button4,OnClickButton4)
ON_EVENT(ON_CLICK,m_button5,OnClickButton5)
ON_EVENT(ON_CHANGE,m_check_group,OnChangeCheckGroup) 
ON_EVENT(ON_CHANGE,m_check_group1,OnChangeCheckGroup1)
ON_EVENT(ON_CHANGE,m_check_group11,OnChangeCheckGroup11) 
ON_EVENT(ON_CHANGE,m_check_group2,OnChangeCheckGroup2) 

//for(int i=0; i<10; i++)
//{
//ON_EVENT(ON_CHANGE, m_combo2[1],OnChangeCombobox2(0))
//}//
     // ON_EVENT(ON_CHANGE,m_combo2[1],OnChangeCombobox6)
     // ON_EVENT(ON_CHANGE,m_combo2[2],OnChangeCombobox10)
ON_EVENT(ON_CHANGE, m_comboExc,OnChangeComboboxExc)
ON_EVENT(ON_CHANGE, m_comboExc2,OnChangeComboboxExc2)
ON_EVENT(ON_CHANGE, m_comboTra,OnChangeComboboxTra)
ON_EVENT(ON_CHANGE, m_comboFil,OnChangeComboboxFilter)
ON_EVENT(ON_CHANGE, m_comboFil2,OnChangeComboboxFilter2)
//ON_OTHER_EVENTS(OnDefault)
EVENT_MAP_END(CAppDialog)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
TVpanel::TVpanel(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
TVpanel::~TVpanel(void)
  {
  }
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool TVpanel::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls
//   if(!CreateListView()) 
//      return(false);

   if(!CreateButtonOK())
      return(false);
   if(!CreateButton1())
      return(false);
   if(!CreateButton2())
      return(false); 
         if(!CreateButton3())
      return(false); 
//      if(!CreateButton4())
//      return(false); 
            if(!CreateButton5())
      return(false); 
//      if(!CreateComboboxExc())
 //     return(false);
 //           if(!CreateComboboxExc2())
 //     return(false);
//       if(!CreateComboboxTra())
//      return(false);
       if(!CreateComboboxFilter())
      return(false);
//if(!CreateComboboxFilter2())
//      return(false);         
         if(!CreateLabels())
      return(false);
//         if(!CreateCheckGroup()) 
//      return(false); 
//      if(!CreateCheckGroup1()) 
//      return(false); 
//      if(!CreateCheckGroup11()) 
//      return(false); 
//      if(!CreateCheckGroup2()) 
//      return(false);       
   
             ArrayResize(m_combo0, NumberOfPatterns, 20);
             ArrayResize(m_combo00, NumberOfPatterns, 20);
             ArrayResize(m_combo00p, NumberOfPatterns, 20);
             ArrayResize(m_combo00n, NumberOfPatterns, 20);
             ArrayResize(m_combo00g, NumberOfPatterns, 20);
       ArrayResize(m_combo1, NumberOfPatterns, 20);
        ArrayResize(m_combo2, NumberOfPatterns, 20);
         ArrayResize(m_combo3, NumberOfPatterns, 20);
          ArrayResize(m_combo3i, NumberOfPatterns, 20);
           ArrayResize(m_combo4, NumberOfPatterns, 20);
           ArrayResize(m_combo5, NumberOfPatterns, 20);
            ArrayResize(m_label, NumberOfPatterns, 20);
            
      int i=0;
      for(i=0; i<NumberOfPatterns; i++)CreateCombobox0(i);
      for(i=0; i<NumberOfPatterns; i++)CreateCombobox00(i);
      for(i=0; i<NumberOfPatterns; i++)CreateCombobox00p(i);
      for(i=0; i<NumberOfPatterns; i++)CreateCombobox00n(i);
      for(i=0; i<NumberOfPatterns; i++)CreateCombobox00g(i);      
      for(i=0; i<NumberOfPatterns; i++)CreateCombobox1(i);
            for(i=0; i<NumberOfPatterns; i++)CreateCombobox2(i);
            for(i=0; i<NumberOfPatterns; i++)CreateCombobox3(i);
            for(i=0; i<NumberOfPatterns; i++)CreateCombobox3i(i);
            CreateEdit();
            CreateEdit2();
            CreateEdit3();
//            for(i=0; i<NumberOfPatterns; i++)CreateCombobox4(i);
//            for(i=0; i<NumberOfPatterns; i++)CreateCombobox5(i);
//            CreateCombobox6();
            CreateCombobox7();
//            CreateCombobox8();
            for(i=0; i<NumberOfPatterns; i++)CreateLabel(i);

   return(true);
  }
//-----------------------------------------------------------
   bool      TVpanel::CreateLabel(int i)
          {
   int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+3;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+30;
   int y2=y1+COMBO_HEIGHT;


     m_label[i].Create(m_chart_id,m_name+"Label"+IntegerToString(i),m_subwin, x1,y1,x2,y2);
   m_label[i].Text("Орб:");
   m_label[i].FontSize(8);
   Add(m_label[i]);
      
      if(UranusImport)m_label[i].Hide();
          
         return(true);
                }
 //-----------------------------------------------------------
   bool      TVpanel::CreateLabels()
          {
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT-13;
   int x2=x1+60;
   int y2=y1+CONTROLS_GAP_Y;
/*
     m_label1.Create(m_chart_id,m_name+"Label1",m_subwin, x1,y1,x2,y2);
   m_label1.Text("Натал_1:");
   m_label1.FontSize(8);
   Add(m_label1);      
   
   x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*2+COMBO_LWIDTH;
   y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT-13;
   x2=x1+30;
   y2=y1+CONTROLS_GAP_Y;

     m_label2.Create(m_chart_id,m_name+"Label2",m_subwin, x1,y1,x2,y2);
   m_label2.Text("Аллюры:");
   m_label2.FontSize(8);
   Add(m_label2);  
     
   x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X;
   y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT-13;
   x2=x1+30;
   y2=y1+CONTROLS_GAP_Y;
  
     m_label3.Create(m_chart_id,m_name+"Label3",m_subwin, x1,y1,x2,y2);
   m_label3.Text("Шаблон 2:");
   m_label3.FontSize(8);
   Add(m_label3);             
 */

         
   x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X;
   y1=ClientAreaHeight()-INDENT_BOTTOM-2*BUTTON_HEIGHT-30;
   x2=x1+60;
   y2=y1+CONTROLS_GAP_Y;

     m_label4.Create(m_chart_id,m_name+"Label4",m_subwin, x1,y1,x2,y2);
   m_label4.Text("Месяц:");
   m_label4.FontSize(8);
   Add(m_label4);          


   x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*2+COMBO_LWIDTH;
   y1=ClientAreaHeight()-INDENT_BOTTOM-2*BUTTON_HEIGHT-30;
   x2=x1+60;
   y2=y1+CONTROLS_GAP_Y;

     m_label5.Create(m_chart_id,m_name+"Label5",m_subwin, x1,y1,x2,y2);
   m_label5.Text("Год:");
   m_label5.FontSize(8);
   Add(m_label5);           
/*
   x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*3+2*COMBO_LWIDTH;
   y1=ClientAreaHeight()-INDENT_BOTTOM-2*BUTTON_HEIGHT-30;
   x2=x1+60;
   y2=y1+CONTROLS_GAP_Y;

     m_label6.Create(m_chart_id,m_name+"Label6",m_subwin, x1,y1,x2,y2);
   m_label6.Text("Что рисуем:");
   m_label6.FontSize(8);
   Add(m_label6);    

   x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*3+2*COMBO_LWIDTH;
   y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT-13;
   x2=x1+30;
   y2=y1+CONTROLS_GAP_Y;
   
     m_label7.Create(m_chart_id,m_name+"Label7",m_subwin, x1,y1,x2,y2);
   m_label7.Text("Натал 2:");
   m_label7.FontSize(8);
   Add(m_label7);   
*/
//   x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*4+3*COMBO_LWIDTH;
//   y1=ClientAreaHeight()-INDENT_BOTTOM-2*BUTTON_HEIGHT-30;
//   x2=x1+30;
//   y2=y1+CONTROLS_GAP_Y;
   
//     m_label8.Create(m_chart_id,m_name+"Label8",m_subwin, x1,y1,x2,y2);
//   m_label8.Text("Шаблон 1:");
//   m_label8.FontSize(8);
//   Add(m_label8);   
   
         return(true);         
                }
                
                
                //+------------------------------------------------------------------+ 
//| Create the "CheckBox" element                                    | 
//+------------------------------------------------------------------+ 
//bool TVpanel::CreateCheckGroup(void) 
//  { 
//--- coordinates 
/*   int x1=INDENT_LEFT; 
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+ (BUTTON_HEIGHT+CONTROLS_GAP_Y)+ (EDIT_HEIGHT+CONTROLS_GAP_Y)+ (EDIT_HEIGHT+CONTROLS_GAP_Y)+ (CONTROLS_GAP_Y); 
   int x2=x1+GROUP_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
   */
/*      int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+10.5*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH;
   int y2=y1+20*COMBO_HEIGHT;
   
   
   
   m_check_group.Create(m_chart_id,m_name+"CheckGroup",m_subwin,x1,y1,x2,y2); 
   Add(m_check_group);

//--- fill out with strings 
   if(!m_check_group.AddItem("Allyr",1<<0))
      return(false);
   if(!m_check_group.AddItem("SP500",1<<1))
      return(false);
   if(!m_check_group.AddItem("NYSE",1<<2))
      return(false);
   if(!m_check_group.AddItem("USA",1<<3))
      return(false);
   if(!m_check_group.AddItem("DJIA",1<<4))
      return(false);      
   if(!m_check_group.AddItem("RTS",1<<5))
      return(false);
   if(!m_check_group.AddItem("YA",1<<6))
      return(false);     
   if(!m_check_group.AddItem("NEFT",1<<7))
      return(false);   
   if(!m_check_group.AddItem("BENZ",1<<8))
      return(false);       
   if(!m_check_group.AddItem("DIST",1<<9))
      return(false);               
//   Comment(__FUNCTION__+" : Value="+IntegerToString(m_check_group.Value())); 
//--- succeed 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
bool TVpanel::CreateCheckGroup1(void) 
  { 
//--- coordinates 
/*   int x1=INDENT_LEFT; 
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+ (BUTTON_HEIGHT+CONTROLS_GAP_Y)+ (EDIT_HEIGHT+CONTROLS_GAP_Y)+ (EDIT_HEIGHT+CONTROLS_GAP_Y)+ (CONTROLS_GAP_Y); 
   int x2=x1+GROUP_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
   
      int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+8*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH/2+2*CONTROLS_GAP_X;
   int y2=y1+10*COMBO_HEIGHT;
   
   
   
   m_check_group1.Create(m_chart_id,m_name+"CheckGroup1",m_subwin,x1,y1,x2,y2); 
   Add(m_check_group1);

//--- fill out with strings 
   if(!m_check_group1.AddItem("Ш 1",1<<0))
      return(false);
   if(!m_check_group1.AddItem("Ш 2",1<<1))
      return(false);
   if(!m_check_group1.AddItem("Ш 3",1<<2))
      return(false);
   if(!m_check_group1.AddItem("Ш 4",1<<3))
      return(false);
   if(!m_check_group1.AddItem("Ш 5",1<<4))
      return(false);              
//   Comment(__FUNCTION__+" : Value1="+IntegerToString(m_check_group1.Value())); 
//--- succeed 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
bool TVpanel::CreateCheckGroup11(void) 
  { 
//--- coordinates 
/*   int x1=INDENT_LEFT; 
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+ (BUTTON_HEIGHT+CONTROLS_GAP_Y)+ (EDIT_HEIGHT+CONTROLS_GAP_Y)+ (EDIT_HEIGHT+CONTROLS_GAP_Y)+ (CONTROLS_GAP_Y); 
   int x2=x1+GROUP_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
  
      int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+8*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(CONTROLS_GAP_Y)+10*COMBO_HEIGHT;;
   int x2=x1+COMBO_WIDTH/2+2*CONTROLS_GAP_X;
   int y2=y1+10*COMBO_HEIGHT;
   
   
   
   m_check_group11.Create(m_chart_id,m_name+"CheckGroup11",m_subwin,x1,y1,x2,y2); 
   Add(m_check_group11);

//--- fill out with strings 
   if(!m_check_group11.AddItem("ШН1",1<<0))
      return(false);
   if(!m_check_group11.AddItem("ШН2",1<<1))
      return(false);
   if(!m_check_group11.AddItem("ШН3",1<<2))
      return(false);
   if(!m_check_group11.AddItem("ШН4",1<<3))
      return(false);
   if(!m_check_group11.AddItem("ШН5",1<<4))
      return(false);              
//   Comment(__FUNCTION__+" : Value1="+IntegerToString(m_check_group1.Value())); 
//--- succeed 
   return(true); 
  }   
//+------------------------------------------------------------------+ 
bool TVpanel::CreateCheckGroup2(void) 
  { 
//--- coordinates 
/*   int x1=INDENT_LEFT; 
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+ (BUTTON_HEIGHT+CONTROLS_GAP_Y)+ (EDIT_HEIGHT+CONTROLS_GAP_Y)+ (EDIT_HEIGHT+CONTROLS_GAP_Y)+ (CONTROLS_GAP_Y); 
   int x2=x1+GROUP_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
   
      int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+3*COMBO_WIDTH+11*CONTROLS_GAP_X;
   int y1=INDENT_TOP+(CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH/2;
   int y2=y1+20*COMBO_HEIGHT;
   
   
   
   m_check_group2.Create(m_chart_id,m_name+"CheckGroup2",m_subwin,x1,y1,x2,y2); 
   Add(m_check_group2);

//--- fill out with strings 
   if(!m_check_group2.AddItem("К",1<<0))
      return(false);
   if(!m_check_group2.AddItem("К",1<<1))
      return(false);
   if(!m_check_group2.AddItem("К",1<<2))
      return(false);
   if(!m_check_group2.AddItem("К",1<<3))
      return(false);
   if(!m_check_group2.AddItem("К",1<<4))
      return(false);      
   if(!m_check_group2.AddItem("К",1<<5))
      return(false);
   if(!m_check_group2.AddItem("К",1<<6))
      return(false);     
   if(!m_check_group2.AddItem("К",1<<7))
      return(false);   
   if(!m_check_group2.AddItem("К",1<<8))
      return(false);       
   if(!m_check_group2.AddItem("К",1<<9))
      return(false);               
   Comment(__FUNCTION__+" : Valu2e="+IntegerToString(m_check_group2.Value())); 
//--- succeed 
   return(true); 
  } 
  
  */
//-----------------------------------------------------
     bool  TVpanel::CreateCombobox0(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/9;
//--- coordinates
   int x1=11;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_SMWIDTH;
   int y2=y1+COMBO_HEIGHT;

m_combo0[i].Create(m_chart_id,m_name+"Combo0"+IntegerToString(i),m_subwin,x1,y1,x2,y2);

Add(m_combo0[i]);
      
      int size=ArraySize(maps);
     for(int j=0;j<size;j++)
    m_combo0[i].AddItem(maps[j],j);

         
           m_combo0[i].Select(0);

     return(true);
  }
  //-----------------------------------------------------
     bool  TVpanel::CreateCombobox00(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/9;
//--- coordinates
   int x1=11+COMBO_SMWIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=(int)x1+COMBO_WIDTH*1.7;
   int y2=(int)y1+COMBO_HEIGHT;

m_combo00[i].Create(m_chart_id,m_name+"Combo_0"+IntegerToString(i),m_subwin,x1,y1,x2,y2);

Add(m_combo00[i]);
      m_combo00[i].AddItem("---",0);
      int size=ArraySize(allyrfile);
     for(int j=0;j<size;j++)
    m_combo00[i].AddItem(allyrfile[j],j+1);
    m_combo00[i].Select(0);

     return(true);
  }
    //-----------------------------------------------------
     bool  TVpanel::CreateCombobox00p(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/9;
//--- coordinates
   int x1=11+COMBO_SMWIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=(int)x1+COMBO_WIDTH*1.7;
   int y2=(int)y1+COMBO_HEIGHT;

m_combo00p[i].Create(m_chart_id,m_name+"Combop0"+IntegerToString(i),m_subwin,x1,y1,x2,y2);
Add(m_combo00p[i]);
      m_combo00p[i].AddItem("---",0);
      int size=ArraySize(usa);
     for(int j=0;j<size;j++)
    m_combo00p[i].AddItem(usa[j],j+1);
    m_combo00p[i].Hide();
     return(true);
  }
    //-----------------------------------------------------
     bool  TVpanel::CreateCombobox00n(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/9;

//--- coordinates
   int x1=11+COMBO_SMWIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH*1.7;
   int y2=y1+COMBO_HEIGHT;

m_combo00n[i].Create(m_chart_id,m_name+"Combon0"+IntegerToString(i),m_subwin,x1,y1,x2,y2);
Add(m_combo00n[i]);
      m_combo00n[i].AddItem("---",0);
      int size=ArraySize(neft);
     for(int j=0;j<size;j++)
    m_combo00n[i].AddItem(neft[j],j+1);
    m_combo00n[i].Hide();
     return(true);
  }  


    //-----------------------------------------------------
     bool  TVpanel::CreateCombobox00g(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/9;

//--- coordinates
   int x1=11+COMBO_SMWIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH*1.7;
   int y2=y1+COMBO_HEIGHT;
m_combo00g[i].Create(m_chart_id,m_name+"Combon0"+IntegerToString(i),m_subwin,x1,y1,x2,y2);
Add(m_combo00g[i]);
      m_combo00g[i].AddItem("---",0);
      int size=ArraySize(gold);
     for(int j=0;j<size;j++)
    m_combo00g[i].AddItem(gold[j],j+1);
    m_combo00g[i].Hide();
     return(true);
  }  
  
  
//------------------------------------------------------
   bool  TVpanel::CreateCombobox1(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT))/6;
//--- coordinates
   int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_combo1[i].Create(m_chart_id,m_name+"Combo1"+IntegerToString(i),m_subwin,x1,y1,x2,y2);

Add(m_combo1[i]);
      
      int size=0;
     if(UranusImport)size=ArraySize(planets); else size=11;
     for(int j=0;j<size;j++)
      m_combo1[i].AddItem(planets[j], j);

   // m_combo1.Alignment(WND_ALIGN_WIDTH,INDENT_LEFT,0,INDENT_RIGHT+sx*2+CONTROLS_GAP_X,0);
        
      // m_combo1.Alignment(WND_ALIGN_LEFT|WND_ALIGN_TOP,0,0,INDENT_LEFT,INDENT_TOP);

                          m_combo1[i].Select(0);

     return(true);
  }
 //----------------------------------------------------------------
     bool  TVpanel::CreateCombobox2(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/9;
//--- coordinates
   int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_SMWIDTH;
   int y2=y1+COMBO_HEIGHT;

m_combo2[i].Create(m_chart_id,m_name+"Combo2"+IntegerToString(i),m_subwin,x1,y1,x2,y2);

Add(m_combo2[i]);
      
      int size=ArraySize(aspects);
     for(int j=0;j<size;j++)
    m_combo2[i].AddItem(aspects[j],j);

         
           m_combo2[i].Select(0);

     return(true);
  }
  //------------------------------------------------------
   bool  TVpanel::CreateCombobox3(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/6;
//--- coordinates
   int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH;
   int y2=y1+COMBO_HEIGHT;

    m_combo3[i].Create(m_chart_id,m_name+"Combo3"+IntegerToString(i),m_subwin,x1,y1,x2,y2);
   Add(m_combo3[i]);

      
      int size=0;
     if(UranusImport)size=ArraySize(planets); else size=11;
     for(int j=0;j<size;j++)
      m_combo3[i].AddItem(planets[j], j);
       
         
                  m_combo3[i].Select(0);

     return(true);
  }   
  
     bool  TVpanel::CreateCombobox3i(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/6;
//--- coordinates
   int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH;
   int y2=y1+COMBO_HEIGHT;

    m_combo3i[i].Create(m_chart_id,m_name+"Combo3i"+IntegerToString(i),m_subwin,x1,y1,x2,y2);

   Add(m_combo3i[i]);
 
   int j;
    for(j=0;j<12;j++)
      m_combo3i[i].AddItem(signsIngression[j], j);
    m_combo3i[i].AddItem("Все", j);
         
           m_combo3i[i].Hide();

     return(true);
  }   

bool  TVpanel::CreateEdit(void)

  {
//--- coordinates
   int x1=11;
   int y1=INDENT_TOP+(NumberOfPatterns+1)*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_SMWIDTH*3;
   int y2=y1+COMBO_HEIGHT;

//--- create
   if(!m_edit.Create(m_chart_id,m_name+"Edit",m_subwin,x1,y1,x2,y2))
      return(false);
//--- разрешим редактировать содержимое
   if(!m_edit.ReadOnly(false))
      return(false);
   if(!Add(m_edit))
      return(false);
//--- succeed
   return(true);
  }
  

bool  TVpanel::CreateEdit2(void)

  {
//--- coordinates
   int x1=22+COMBO_SMWIDTH*3;
   int y1=INDENT_TOP+(NumberOfPatterns+1)*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_SMWIDTH*3;
   int y2=y1+COMBO_HEIGHT;

//--- create
   if(!m_edit2.Create(m_chart_id,m_name+"Edit2",m_subwin,x1,y1,x2,y2))
      return(false);
//--- разрешим редактировать содержимое
   if(!m_edit2.ReadOnly(false))
      return(false);
   if(!Add(m_edit2))
      return(false);
//--- succeed
   return(true);
  }  

bool  TVpanel::CreateEdit3(void)

  {
   int x1=33+COMBO_SMWIDTH*7;
   int y1=INDENT_TOP+(NumberOfPatterns+1)*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_SMWIDTH;
   int y2=y1+COMBO_HEIGHT;
//--- create
   if(!m_edit3.Create(m_chart_id,m_name+"Edit3",m_subwin,x1,y1,x2,y2))
      return(false);
//--- разрешим редактировать содержимое
   if(!m_edit3.ReadOnly(false))
      return(false);
   if(!Add(m_edit3))
      return(false);
//--- succeed
   return(true);
  } 
//-----------------------------------------------------------------------
/*     bool  TVpanel::CreateCombobox4(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/9;
//--- coordinates
   int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+20;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH/2;
   int y2=y1+COMBO_HEIGHT;

     m_combo4[i].Create(m_chart_id,m_name+"Combo4"+IntegerToString(i),m_subwin,x1,y1,x2,y2);
  Add(m_combo4[i]);
 
      
     for(int j=0;j<8;j++)
      m_combo4[i].AddItem(j,j);

         
         m_combo4[i].Select(0);
         
         if(UranusImport)m_combo4[i].Hide();
         
     return(true);
  }  
  
//----------------------------------------------------------------------- new
/*     bool  TVpanel::CreateCombobox5(int i)
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/12;
//--- coordinates
   int x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+20;
   int y1=INDENT_TOP+i*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_WIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_combo5[i].Create(m_chart_id,m_name+"Combo5"+IntegerToString(i),m_subwin,x1,y1,x2,y2);
  Add(m_combo5[i]);
       int size=0;
      size=ArraySize(colors);
     for(int j=0;j<size;j++)
      m_combo5[i].AddItem(colors[j],j);

         
         m_combo5[i].Select(0);
         m_combo5[i].Hide();
         
     return(true);
  }
    */
    //----------------------------------------------------------------------- new
    bool  TVpanel::CreateCombobox6()
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/12;
//--- coordinates

   
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-2*BUTTON_HEIGHT-13;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_combo6.Create(m_chart_id,m_name+"Combo6",m_subwin,x1,y1,x2,y2);
  Add(m_combo6);
       int size=0;
      size=ArraySize(month);
     for(int j=0;j<size;j++)
      m_combo6.AddItem(month[j],j);

         
         m_combo6.Select(0);
         
         
     return(true);
  }
    
        //----------------------------------------------------------------------- new
     bool  TVpanel::CreateCombobox7()
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/12;
//--- coordinates

   
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*2+COMBO_LWIDTH;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-2*BUTTON_HEIGHT-13;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_combo7.Create(m_chart_id,m_name+"Combo7",m_subwin,x1,y1,x2,y2);
  Add(m_combo7);
       int size=0;
      size=ArraySize(year);
     for(int j=0;j<size;j++)
      m_combo7.AddItem(year[j],j);

         
         m_combo7.Select(0);
         
         
     return(true);
  }



//+------------------------------------------------------------------+
//--- Time Functions ------------------------------------------------+
//+------------------------------------------------------------------+
int TimeYear     (datetime date){MqlDateTime time;TimeToStruct(date,time);return(time.year);}
int TimeMonth    (datetime date){MqlDateTime time;TimeToStruct(date,time);return(time.mon);}
int TimeDayOfYear(datetime date){MqlDateTime time;TimeToStruct(date,time);return(time.day_of_year);}
int TimeDayOfWeek(datetime date){MqlDateTime time;TimeToStruct(date,time);return(time.day_of_week);}
int TimeDay      (datetime date){MqlDateTime time;TimeToStruct(date,time);return(time.day);}
int TimeHour     (datetime date){MqlDateTime time;TimeToStruct(date,time);return(time.hour);}
int TimeMinute   (datetime date){MqlDateTime time;TimeToStruct(date,time);return(time.min);}
int TimeSeconds   (datetime date){MqlDateTime time;TimeToStruct(date,time);return(time.sec);}

        //----------------------------------------------------------------------- new
 /*    bool  TVpanel::CreateCombobox8()
  {
   int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/12;
//--- coordinates

   
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*3+2*COMBO_LWIDTH;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-2*BUTTON_HEIGHT-13;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;
     m_combo8.Create(m_chart_id,m_name+"Combo8",m_subwin,x1,y1,x2,y2);
  Add(m_combo8);
       int size=0;
      size=ArraySize(risuem);
     for(int j=0;j<size;j++)
      m_combo8.AddItem(risuem[j],j);

         
         m_combo8.Select(0);
         
         
     return(true);
  }
*/
    
//+------------------------------------------------------------------+
//| Create the display field                                         | текстовое поле справа
//+------------------------------------------------------------------+
/*bool TVpanel::CreateListView(void)
  {
  int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT+BUTTON_WIDTH))/6;
//--- coordinates
   int x1;
   if(!UranusImport)x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+20;
   else x1=INDENT_LEFT+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH*4+CONTROLS_GAP_X;
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH; if(UranusImport)x2+=COMBO_SMWIDTH+CONTROLS_GAP_X+20;
   int y2=y1+NumberOfPatterns*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   
   //Print(ClientAreaHeight(), " ", ClientAreaWidth());
//--- create
   if(!m_list_view.Create(m_chart_id,m_name+"List",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_list_view))
      return(false);
      
  // m_edit.Alignment(WND_ALIGN_LEFT,INDENT_LEFT,0,INDENT_RIGHT,0);
//--- succeed
   return(true);
  }
  */
//+------------------------------------------------------------------+
//| Create the "Button1" button                                      | кнопка ok
//+------------------------------------------------------------------+
bool TVpanel::CreateButtonOK(void)
  {
//--- coordinates
   int x1=33+COMBO_SMWIDTH*6;
   int y1=INDENT_TOP+(NumberOfPatterns+1)*(COMBO_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBO_SMWIDTH;
   int y2=y1+COMBO_HEIGHT;
//--- create
   if(!m_buttonOK.Create(m_chart_id,m_name+"ButtonOK",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_buttonOK.Text("OK"))
      return(false);
   if(!Add(m_buttonOK))
      return(false);
  // m_button1.Alignment(WND_ALIGN_LEFT,0,0,INDENT_LEFT,0);
  // m_button1.Alignment(WND_ALIGN_LEFT|WND_ALIGN_BOTTOM,0,0,INDENT_LEFT,INDENT_BOTTOM);

//--- succeed
   return(true);
  } 





//+------------------------------------------------------------------+
//| Create the "Button1" button                                      | кнопка найти
//+------------------------------------------------------------------+
bool TVpanel::CreateButton1(void)
  {
//--- coordinates
   int x1=INDENT_RIGHT;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT;
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button1.Create(m_chart_id,m_name+"Button1",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button1.Text("Найти"))
      return(false);
   if(!Add(m_button1))
      return(false);
  // m_button1.Alignment(WND_ALIGN_LEFT,0,0,INDENT_LEFT,0);
  // m_button1.Alignment(WND_ALIGN_LEFT|WND_ALIGN_BOTTOM,0,0,INDENT_LEFT,INDENT_BOTTOM);

//--- succeed
   return(true);
  } 
//+------------------------------------------------------------------+
//| Create the "Button2" button                                      |
//+------------------------------------------------------------------+ кнопка сохранить
bool TVpanel::CreateButton2(void)
  {
//--- coordinates
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT;
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button2.Create(m_chart_id,m_name+"Button2",m_subwin,x1,y1,x2,y2))
      return(false);
      
   if(!m_button2.Text("Сохранить"))return(false);

   
   if(!Add(m_button2))
      return(false);
 //  m_button2.Alignment(WND_ALIGN_LEFT,0,0,INDENT_LEFT,0);
//--- succeed
   return(true);
  }
//===================================================================== кнопка сбросить
  bool TVpanel::CreateButton3(void)
  {
//--- coordinates
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT;
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button3.Create(m_chart_id,m_name+"Button3",m_subwin,x1,y1,x2,y2))
      return(false);
      
   if(!m_button3.Text("Сбросить"))return(false);

   
   if(!Add(m_button3))
      return(false);
 //  m_button2.Alignment(WND_ALIGN_LEFT,0,0,INDENT_LEFT,0);
//--- succeed
   return(true);
  }
/*
//===================================================================== кнопка нарисовать
  bool TVpanel::CreateButton4(void)
  {
//--- coordinates
   int x1=INDENT_RIGHT;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-2.5*BUTTON_HEIGHT;
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button4.Create(m_chart_id,m_name+"Button4",m_subwin,x1,y1,x2,y2))
      return(false);
      
   if(!m_button4.Text("Нарисовать"))return(false);

   
   if(!Add(m_button4))
      return(false);
 //  m_button2.Alignment(WND_ALIGN_LEFT,0,0,INDENT_LEFT,0);
//--- succeed
   return(true);
  }
*/
//+------------------------------------------------------------------+
//| Create the "Button5" button                                      |
//+------------------------------------------------------------------+ кнопка сохранить
bool TVpanel::CreateButton5(void)
  {
//--- coordinates
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*2+COMBO_LWIDTH;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;
//--- create
   if(!m_button5.Create(m_chart_id,m_name+"Button5",m_subwin,x1,y1,x2,y2))
      return(false);
      
   if(!m_button5.Text("Открыть"))return(false);

   
   if(!Add(m_button5))
      return(false);
 //  m_button2.Alignment(WND_ALIGN_LEFT,0,0,INDENT_LEFT,0);
//--- succeed
   return(true);
  }
/*
  //========================================================================= выбор экселей
     bool  TVpanel::CreateComboboxExc()
  {//--- coordinates
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_comboExc.Create(m_chart_id,m_name+"ComboExc",m_subwin,x1,y1,x2,y2);

    Add(m_comboExc);
      
      string fname, ftype;
      int flength, i=0;
      long fsearch=FileFindFirst(DirectoryNameN+"\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist(DirectoryNameN + "\\" + fname)){
            flength=StringLen(fname); 
            ftype=StringSubstr(fname, flength-7, 3);//Print(StringSubstr(fname, flength-7, 3));}
            if(ftype!="DIR" && ftype!="MIN" && ftype!="PRO" && ftype!="TRE" && ftype!="4NE" && fname!=UranusAllureFileName && fname!=UranusIngressionFileName && fname!=NatalFileName && fname!=TransitFileName)
            m_comboExc.AddItem(StringSubstr(fname, 0, flength-4), i);
            i++;}
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);
     
//     m_comboExc.ItemInsert(0, "НЕТ", 0);
     
      /*
      int size=0;
     if(UranusImport)size=ArraySize(planets); else size=11;
     for(int j=0;j<size;j++)
      m_combo1[i].AddItem(planets[j], j);

   // m_combo1.Alignment(WND_ALIGN_WIDTH,INDENT_LEFT,0,INDENT_RIGHT+sx*2+CONTROLS_GAP_X,0);
        
      // m_combo1.Alignment(WND_ALIGN_LEFT|WND_ALIGN_TOP,0,0,INDENT_LEFT,INDENT_TOP);


                          m_comboExc.Select(0); 
     return(true);
  }
  
    //========================================================================= выбор экселей2
     bool  TVpanel::CreateComboboxExc2()
  {//--- coordinates
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*3+2*COMBO_LWIDTH;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_comboExc2.Create(m_chart_id,m_name+"ComboExc2",m_subwin,x1,y1,x2,y2);

    Add(m_comboExc2);
      
      string fname, ftype;
      int flength, i=0;
      long fsearch=FileFindFirst(DirectoryNameN+"\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist(DirectoryNameN + "\\" + fname)){
            flength=StringLen(fname); 
            ftype=StringSubstr(fname, flength-7, 3);//Print(StringSubstr(fname, flength-7, 3));}
            if(ftype!="DIR" && ftype!="MIN" && ftype!="PRO" && ftype!="TRE" && ftype!="4NE" && fname!=UranusAllureFileName && fname!=UranusIngressionFileName && fname!=NatalFileName && fname!=TransitFileName)
            m_comboExc2.AddItem(StringSubstr(fname, 0, flength-4), i);
            i++;}
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);
     
//     m_comboExc2.ItemInsert(0, "НЕТ", 0);
     
      /*
      int size=0;
     if(UranusImport)size=ArraySize(planets); else size=11;
     for(int j=0;j<size;j++)
      m_combo1[i].AddItem(planets[j], j);

   // m_combo1.Alignment(WND_ALIGN_WIDTH,INDENT_LEFT,0,INDENT_RIGHT+sx*2+CONTROLS_GAP_X,0);
        
      // m_combo1.Alignment(WND_ALIGN_LEFT|WND_ALIGN_TOP,0,0,INDENT_LEFT,INDENT_TOP);


                          m_comboExc2.Select(1); 
     return(true);
  }
  
  
 //========================================================================= выбор аллюров
     bool  TVpanel::CreateComboboxTra()
  {//--- coordinates
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*2+COMBO_LWIDTH;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_comboTra.Create(m_chart_id,m_name+"ComboTra",m_subwin,x1,y1,x2,y2);

    Add(m_comboTra);
      
      string fname, ftype;
      int flength, i=0;
      long fsearch=FileFindFirst(DirectoryName+"\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist(DirectoryName + "\\" + fname)){
            flength=StringLen(fname); 
            ftype=StringSubstr(fname, flength-7, 3);//Print(StringSubstr(fname, flength-7, 3));}
            if(ftype!="DIR" && ftype!="MIN" && ftype!="PRO" && ftype!="TRE" && ftype!="4NE" && fname!=UranusAllureFileName && fname!=UranusIngressionFileName && fname!=NatalFileName && fname!=TransitFileName)
            m_comboTra.AddItem(StringSubstr(fname, 0, flength-4), i);
            i++;}
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);         
//          m_comboTra.ItemInsert(0, "НЕТ", 0);

                          m_comboTra.Select(0); 
     return(true);
  }
*/  
 //========================================================================= выбор фильтров
     bool  TVpanel::CreateComboboxFilter()
  {//--- coordinates
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-BUTTON_HEIGHT;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_comboFil.Create(m_chart_id,m_name+"ComboFil",m_subwin,x1,y1,x2,y2);

    Add(m_comboFil);
      
      string fname, ftype;
      int flength, i=0;
      long fsearch=FileFindFirst(DirectoryNameS+"\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist(DirectoryNameS + "\\" + fname)){
            flength=StringLen(fname); 
            ftype=StringSubstr(fname, flength-7, 3);//Print(StringSubstr(fname, flength-7, 3));}
            m_comboFil.AddItem(StringSubstr(fname, 0, flength-4), i);
            i++;}
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);         
    m_comboFil.ItemInsert(0, "НЕТ", 0);
    globalcount=i;
                          m_comboFil.Select(0); 
     return(true);
  }/*
 //========================================================================= выбор фильтров
     bool  TVpanel::CreateComboboxFilter2()
  {//--- coordinates
   int x1=INDENT_RIGHT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH+CONTROLS_GAP_X*4+3*COMBO_LWIDTH;
   int y1=ClientAreaHeight()-INDENT_BOTTOM-2*BUTTON_HEIGHT-13;
   int x2=x1+COMBO_LWIDTH;
   int y2=y1+COMBO_HEIGHT;

     m_comboFil2.Create(m_chart_id,m_name+"ComboFil2",m_subwin,x1,y1,x2,y2);

    Add(m_comboFil2);
      
      string fname, ftype;
      int flength, i=0;
      long fsearch=FileFindFirst(DirectoryNameS+"\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist(DirectoryNameS + "\\" + fname)){
            flength=StringLen(fname); 
            ftype=StringSubstr(fname, flength-7, 3);//Print(StringSubstr(fname, flength-7, 3));}
            m_comboFil2.AddItem(StringSubstr(fname, 0, flength-4), i);
            i++;}
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);         
    m_comboFil2.ItemInsert(0, "НЕТ", 0);
    
                          m_comboFil2.Select(0); 
     return(true);
  }
  
 */   
  
//+------------------------------------------------------------------+
//| Handler of resizing                                              |
//+------------------------------------------------------------------+
bool TVpanel::OnResize(void)
  {
//--- call method of parent class
   if(!CAppDialog::OnResize()) return(false);
//--- coordinates
   int x=ClientAreaLeft()+INDENT_LEFT;
   int y=ClientAreaTop();
      int sx=(ClientAreaWidth()-(INDENT_LEFT+INDENT_RIGHT))/6;

   
  int ybut=ClientAreaBottom()-(INDENT_BOTTOM+BUTTON_HEIGHT);
   int xbut2=ClientAreaLeft()+INDENT_LEFT+BUTTON_WIDTH+CONTROLS_GAP_X;
//--- move and resize the "ListView" element

//x=ClientAreaRight()-(INDENT_RIGHT+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+20+EDIT_WIDTH);
m_button1.Move(x, ybut);
m_button2.Move(xbut2, ybut);
/*
   m_combo1.Move(x, y);
   m_combo1.Width(sx);
   
   x=ClientAreaLeft()+INDENT_LEFT+COMBO_WIDTH+CONTROLS_GAP_X;
   
      m_combo2.Move(x, y);
   m_combo2.Width(COMBO_SMWIDTH);
   
   x=ClientAreaLeft()+INDENT_LEFT+COMBO_WIDTH+COMBO_SMWIDTH+CONTROLS_GAP_X*2;

      m_combo3.Move(x, y);
   m_combo3.Width(COMBO_WIDTH);
   
   x=ClientAreaLeft()+INDENT_LEFT+COMBO_WIDTH+COMBO_SMWIDTH+CONTROLS_GAP_X*3+COMBO_WIDTH+20;
  
   m_combo4.Move(x, y);
   m_combo4.Width(COMBO_SMWIDTH); */
  
  //x=ClientAreaLeft()+INDENT_LEFT+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+COMBO_WIDTH+CONTROLS_GAP_X+COMBO_SMWIDTH+CONTROLS_GAP_X+20;
  // m_list_view.Move(x,y);
 // m_list_view.Width(EDIT_WIDTH);
   
  if(!m_minimized)for(int i=0; i<NumberOfPatterns; i++)
  {
   if(UranusImport){m_combo4[i].Hide(); m_label[i].Hide();}
   if(m_combo2[i].Select()=="Ингр."){m_combo3[i].Hide(); m_combo3i[i].Show();}
   else {m_combo3i[i].Hide();m_combo3[i].Show(); }
  }
 
//--- succeed
   return(true);
  } 
  
void TVpanel::OnClickButtonOK(void)
{
int i1=0;string newstr1,met;
int j=0;
            int copy, copyL, copyH;
            double pricedata[1]; pricedata[0]=0;
            double pricedataL[1];pricedataL[0]=0;
            double pricedataH[1];pricedataH[0]=0;
            int ddd=1;
                     color codecolor=clrRed;int codedraw;
         string fname, ftype;
         int countasp=1;
         int dayscluster=StringToInteger(m_edit3.Text());
         datetime datedraw[20000],datetemp,dd[20000];
         string aspectdraw[20000],asptemp,filenames[20000],metod[20000];
         
         int icountstring;
         datetime date,drawdate; string aspect;
      long fsearch=FileFindFirst(m_edit.Text()+"\\*", fname);Print(m_edit3.Text());
if (m_edit3.Text()==""){
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist(m_edit.Text()+"\\" + fname))
               {
                    Print(fname);    
//                    
     int exceltxt1=FileOpen(m_edit.Text()+"\\" + fname,FILE_READ|FILE_TXT|InpEncodingType);
if(exceltxt1!=INVALID_HANDLE)
   {
       for(i1=0; !FileIsEnding(exceltxt1); i1++)
      {
      newstr1=FileReadString(exceltxt1);
      
//начало раскраски      
 if (StringFind(newstr1,"Ингрессии",0)>=0) met=newstr1;
 if (StringFind(newstr1,"ПЕТЛИ",0)>=0) met=newstr1;
 if (StringFind(newstr1,"Текущие аспекты",0)>=0) met=newstr1;
  if (StringFind(newstr1,"К натальной карте",0)>=0) met=newstr1;
  if (StringFind(newstr1,"ОСТАНОВКИ",0)>=0) {met=newstr1;}
if (StringFind(newstr1,"Метод",0)>=0) met=newstr1;

   if (StringFind(met,"Ингрессии",0)>=0)
      {
   date=StringToTime(StringSubstr(newstr1, 1, 10)+StringSubstr(newstr1, 11, 6));
   aspect=StringSubstr(newstr1, 20,StringLen(newstr1)-20);
      codecolor=clrWhite;codedraw=81; //Print(aspect,date);
      }else 
   if (StringFind(met,"ОСТАНОВКИ",0)>=0)  
      {
   date=StringToTime(StringSubstr(newstr1, 1, 10)+StringSubstr(newstr1, 11, 6));
   aspect=StringSubstr(newstr1, 20,StringLen(newstr1)-20); 
           if (StringFind(aspect,"R",0)>=0) codecolor =clrWhite;codedraw=162; 
           if (StringFind(aspect,"D",0)>=0) codecolor =clrYellow;codedraw=162; 
    }else 
        if((StringFind(aspect,"60",0)>=0)||(StringFind(aspect,"120",0)>=0))     // А для событий по нашему ..
        {codecolor =clrGreen;codedraw=241;}else
        if(StringFind(aspect,"90",0)>=0){codecolor =clrRed;codedraw=242;}else
        if(StringFind(aspect,"180",0)>=0){codecolor =clrRed;codedraw=242;}else
        if(StringFind(aspect,"45",0)>=0){codecolor =clrRed;codedraw=242;}else
        if(StringFind(aspect,"135",0)>=0){codecolor =clrRed;codedraw=242;}else
        if((StringFind(aspect," 0.0",0)>=0)){codecolor =clrYellow;codedraw=108;}      
/*   if (StringFind(met,"К натальной карте",0)>=0)
      {
   date=StringToTime(StringSubstr(newstr1, 1, 10)+StringSubstr(newstr1, 11, 6)); 
   aspect=StringSubstr(newstr1, 23, 3)+" "+StringSubstr(newstr1, 27, 12)+" "+StringToInteger(StringSubstr(newstr1, 40, 3));//Print(aspect);
   codecolor=clrDeepSkyBlue;codedraw=116;
      if (StringFind(met,"США",0)>=0)
              {codecolor =clrDarkOrchid;codedraw=178;}
      if (StringFind(met,"SP500",0)>=0)
              {codecolor =clrBlue;codedraw=118;}
         if (StringFind(met,"DJIA",0)>=0)
              {codecolor =clrMagenta;codedraw=91;}
        if (StringFind(met,"NYSE",0)>=0)
         {codecolor =clrWhite;codedraw=82;}
            if (StringFind(met,"Нефть",0)>=0)
              {codecolor =clrAqua;codedraw=74;} 
         if (StringFind(met,"БЕНЗИН",0)>=0)
              {codecolor =clrMediumVioletRed;codedraw=74;} 
        if (StringFind(met,"Дистилляты",0)>=0)
            {codecolor =clrOrange;codedraw=74;}}
        if(StringFind(met,"Профекции",0)>=0) {codecolor=clrBlue;} 
         if((StringFind(met,"Минор",0)>=0)||(StringFind(met,"трет",0)>=0))
         {codecolor =clrOrange;}
*/
   if (StringFind(met,"К натальной карте",0)>=0)
      {
   codecolor=clrDeepSkyBlue;codedraw=116;
      if (StringFind(met,"США",0)>=0)
              {codecolor =clrDarkOrchid;codedraw=178;}
      if (StringFind(met,"SP500",0)>=0)
              {codecolor =clrBlue;codedraw=118;}
         if (StringFind(met,"DJIA",0)>=0)
              {codecolor =clrMagenta;codedraw=91;}
        if (StringFind(met,"NYSE",0)>=0)
         {codecolor =clrWhite;codedraw=82;}
            if (StringFind(met,"Нефть",0)>=0)
              {codecolor =clrAqua;codedraw=74;} 
         if (StringFind(met,"БЕНЗИН",0)>=0)
              {codecolor =clrMediumVioletRed;codedraw=74;} 
        if (StringFind(met,"Дистилляты",0)>=0)
            {codecolor =clrOrange;codedraw=74;}}
        if(StringFind(met,"Профекции",0)>=0) {codecolor=clrBlue;}
         if((StringFind(met,"Минор",0)>=0)||(StringFind(met,"трет",0)>=0))
         {codecolor =clrOrange;}

//Print(met,codecolor,codedraw);
//конец раскраски       
      int i=0; string newstr;
  int exceltxt=FileOpen(m_edit2.Text(),FILE_READ|FILE_TXT|InpEncodingType);
if(exceltxt!=INVALID_HANDLE)
   {
       for(i=0; !FileIsEnding(exceltxt); i++)
      {
      newstr=FileReadString(exceltxt); 
      if(StringFind(newstr1,newstr,0)>=0)
         {
            Print(fname+","+newstr1);
            date=StringToTime(StringSubstr(newstr1, 1, 10)+StringSubstr(newstr1, 11, 6));
            aspect=StringSubstr(newstr1, 20,StringLen(newstr1)-20);
            drawdate=date;
            MqlDateTime str;
            TimeToStruct(date, str);
            if(str.day_of_week==0)drawdate=date+86400;
            if(str.day_of_week==6)drawdate=date-86400;
            copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
            if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); 
            DrawSymb(date, pricedataH[0]*MathPow(1.01,countasp), codecolor, codedraw, "",fname+"/"+aspect);
         }      
      }   
   }FileFindClose(exceltxt);    
      }   
   }FileFindClose(exceltxt1); 
//                     
               }
            }
            while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);    }//добавлено начало если есть кол-во edit3
     else
     {
     int exceltxt=FileOpen(m_edit2.Text(),FILE_READ|FILE_TXT|InpEncodingType);
      if(exceltxt!=INVALID_HANDLE)
   {
       for(i1=0; !FileIsEnding(exceltxt); i1++)
      {
      newstr1=FileReadString(exceltxt);
      }icountstring=i1;FileClose(exceltxt);
   }
     Print(icountstring);

     if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist(m_edit.Text()+"\\" + fname))
               {
                    Print(fname);    
//                    
     int exceltxt1=FileOpen(m_edit.Text()+"\\" + fname,FILE_READ|FILE_TXT|InpEncodingType);
      if(exceltxt1!=INVALID_HANDLE)
   {string met1;
       for(i1=0; !FileIsEnding(exceltxt1); i1++)
      {
      newstr1=FileReadString(exceltxt1);
         int exceltxt=FileOpen(m_edit2.Text(),FILE_READ|FILE_TXT|InpEncodingType);
         if(exceltxt!=INVALID_HANDLE)
         {
            for(int i=0; !FileIsEnding(exceltxt); i++)
            {
            string newstr=FileReadString(exceltxt); 
            //цвета
               date=StringToTime(StringSubstr(newstr1, 1, 10)+StringSubstr(newstr1, 11, 6));
   aspect=StringSubstr(newstr1, 20,StringLen(newstr1)-20);
             if (StringFind(newstr1,"Ингрессии",0)>=0) {met1=newstr1;}
 if (StringFind(newstr1,"ПЕТЛИ",0)>=0) met1=newstr1;
 if (StringFind(newstr1,"Текущие аспекты",0)>=0) met1=newstr1;
  if (StringFind(newstr1,"К натальной карте",0)>=0) met1=newstr1;
  if (StringFind(newstr1,"ОСТАНОВКИ",0)>=0) {met1=newstr1;}
      
            
            //
            if (StringLen(newstr)>7) 
            {if((StringFind(newstr1,StringSubstr(newstr, 0, 4),0)>=0)&&(StringFind(newstr1,StringSubstr(newstr, 4, 4),0)>=0)&&(StringFind(newstr1,StringSubstr(newstr, 8, StringLen(newstr)-8),0)>=0))
               {
               datedraw[j]=StringToTime(StringSubstr(newstr1, 1, 10)+StringSubstr(newstr1, 11, 6));
               aspectdraw[j]=StringSubstr(newstr1, 20, StringLen(newstr1)-20);
               filenames[j]=fname;
               metod[j]=met1;//Print(metod[j]);
               j++;
               }
               }
               else 
               if (StringLen(newstr)>4)
                  {if((StringFind(newstr1,StringSubstr(newstr, 0, 4),0)>=0)&&(StringFind(newstr1,StringSubstr(newstr, 4, 4),0)>=0))
               {
               datedraw[j]=StringToTime(StringSubstr(newstr1, 1, 10)+StringSubstr(newstr1, 11, 6));
               aspectdraw[j]=StringSubstr(newstr1, 20, StringLen(newstr1)-20);
               filenames[j]=fname;
               metod[j]=met1;//Print(metod[j]);
               j++;
               }
               }
               else               
               {if(StringFind(newstr1,StringSubstr(newstr, 0, 4),0)>=0)
               {
               datedraw[j]=StringToTime(StringSubstr(newstr1, 1, 10)+StringSubstr(newstr1, 11, 6));
               aspectdraw[j]=StringSubstr(newstr1, 20, StringLen(newstr1)-20);
               filenames[j]=fname;
               metod[j]=met1;//Print(metod[j]);
               j++;
               }
               }
             }
          }FileFindClose(exceltxt);
               }
            }FileFindClose(exceltxt1);
      } //конец цикла edit3 цифра  
} while(FileFindNext(fsearch, fname));FileFindClose(fsearch); 
}  

for(int z=0;z<j;z++)
for(int z1=0;z1<j;z1++)
if (datedraw[z1]>datedraw[z])
   {
      datetemp=datedraw[z];
      datedraw[z]=datedraw[z1];
      datedraw[z1]=datetemp;
      asptemp=aspectdraw[z];
      aspectdraw[z]=aspectdraw[z1];
      aspectdraw[z1]=asptemp;
      string temp;
      temp=filenames[z];
      filenames[z]=filenames[z1];
      filenames[z1]=temp;
      temp=metod[z];
      metod[z]=metod[z1];
      metod[z1]=temp;
   }
for(int z=1;z<j;z++)
if ((datedraw[z]==datedraw[z-1])&&(aspectdraw[z]==aspectdraw[z-1]))
   {
      datedraw[z]=datedraw[z+1];
      aspectdraw[z]=aspectdraw[z+1];
      filenames[z]=filenames[z+1];
      metod[z]=metod[z+1];
   }
for (int l=0;l<j-icountstring;l++)
   {//Print(drawdate,"|",aspect,"|",met,"|",StringToTime(datedraw[l+icountstring-1]),"|",StringToTime(datedraw[l]),"|",StringToTime(datedraw[l])+86400*dayscluster,"|",StringToTime(datedraw[l+icountstring-1]),"|",StringToTime(datedraw[l+icountstring-1])-StringToTime(datedraw[l])<=86400*dayscluster);
      int test=0;
      if (StringToTime(datedraw[l+icountstring-1])-StringToTime(datedraw[l])<=86400*dayscluster)
         for (int d1=0;d1<icountstring;d1++)
         for (int d2=0;d2<icountstring;d2++)
            if (aspectdraw[l+d1]==aspectdraw[l+d2]) test++;
         if (test==icountstring)
         for (int d=0;d<icountstring;d++)
            {
               drawdate=datedraw[l+d];
               aspect=aspectdraw[l+d];
               met=metod[l+d];
              // Print(drawdate,"|",aspect,"|",met,"|",StringToTime(datedraw[l+icountstring-1]),"|",StringToTime(datedraw[l]),StringToTime(datedraw[l+icountstring-1])-StringToTime(datedraw[l])<=86400*dayscluster);
//начало раскраски      


   if (StringFind(met,"Ингрессии",0)>=0)
      {

      codecolor=clrWhite;codedraw=81; //Print(aspect,date,met);
      }else 
   if (StringFind(met,"ОСТАНОВКИ",0)>=0)  
      {
           if (StringFind(aspect,"R",0)>=0) codecolor =clrWhite;codedraw=162; 
           if (StringFind(aspect,"D",0)>=0) codecolor =clrYellow;codedraw=162; 
    }; 
        if((StringFind(aspect,"60",0)>=0)||(StringFind(aspect,"120",0)>=0))     // А для событий по нашему ..
        {codecolor =clrGreen;codedraw=241;}else
        if(StringFind(aspect,"90",0)>=0){codecolor =clrRed;codedraw=242;}else
        if(StringFind(aspect,"180",0)>=0){codecolor =clrRed;codedraw=242;}else
        if(StringFind(aspect,"45",0)>=0){codecolor =clrRed;codedraw=242;}else
        if(StringFind(aspect,"135",0)>=0){codecolor =clrRed;codedraw=242;}else
        if((StringFind(aspect," 0.0",0)>=0)){codecolor =clrYellow;codedraw=108;}

        
   if (StringFind(met,"К натальной карте",0)>=0)
      {
   codecolor=clrDeepSkyBlue;codedraw=116;
      if (StringFind(met,"США",0)>=0)
              {codecolor =clrDarkOrchid;codedraw=178;}
      if (StringFind(met,"SP500",0)>=0)
              {codecolor =clrBlue;codedraw=118;}
         if (StringFind(met,"DJIA",0)>=0)
              {codecolor =clrMagenta;codedraw=91;}
        if (StringFind(met,"NYSE",0)>=0)
         {codecolor =clrWhite;codedraw=82;}
            if (StringFind(met,"Нефть",0)>=0)
              {codecolor =clrAqua;codedraw=74;} 
         if (StringFind(met,"БЕНЗИН",0)>=0)
              {codecolor =clrMediumVioletRed;codedraw=74;} 
        if (StringFind(met,"Дистилляты",0)>=0)
            {codecolor =clrOrange;codedraw=74;}}
        if(StringFind(met,"Профекции",0)>=0) {codecolor=clrBlue;}
         if((StringFind(met,"Минор",0)>=0)||(StringFind(met,"трет",0)>=0))
         {codecolor =clrOrange;}

//Print(met,codecolor,codedraw);
//конец раскраски       
        bool drawyes=1;
//        for (int k=0;k<=ddd;k++) {if (dd[k]==drawdate) drawyes=0;}
        if (drawyes)
        {       
               MqlDateTime str;
               TimeToStruct(drawdate, str);
               if(str.day_of_week==0)drawdate=drawdate+86400;
               if(str.day_of_week==6)drawdate=drawdate-86400;
               copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
               if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); 
               DrawSymb(drawdate, pricedataH[0]*MathPow(1.01,countasp), codecolor, codedraw, "",aspect+"/"+filenames[l+d]);
               Print("|",drawdate,"|",aspect,"|",filenames[l+d],"|",l+d);
               dd[ddd]=drawdate;ddd++;
               drawyes=false;
         }
            }
   }



}  
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void TVpanel::OnClickButton1(void) 
  {       // Print(m_combo3i[0].Select());
      ObjectsDeleteAll(ChartID(), 0, OBJ_ARROW);
      m_list_view.ItemsClear();
      color patternclr=clrWhite; int ind=0;
/* if (m_combo0[0].Select()==maps[0]) if ((m_combo1[0].Select()=="---") && m_combo3[0].Select()=="---"){
 
 
  //for (int z=1; z<ArraySize(planets);z++) for (int y=1; y<ArraySize(planets);y++) UranusSearchAspect(z, y, StringToInteger(m_combo2[0].Select()), patternclr, planets[z]+" "+m_combo2[0].Select()+" "+planets[y]);
  
  
  
  
}*/
    for(int i=0; i<NumberOfPatterns; i++)
  { 
  // if(m_combo1[i].Select()== m_combo3[i].Select() && m_combo1[i].Value()!=0 && m_combo0[i].Value()=="Аллюр" && m_combo2[i].Select()!="Ингр."){m_list_view.ItemInsert(0, "Одинаковые планеты"); continue;}
  // if((m_combo1[i].Value()==0 || m_combo3[i].Value()==0) && m_combo2[i].Select()!="Ингр.")continue;
       patternclr=clrWhite; 
   int f;
   ExcelFileName=m_comboExc.Select()+".txt";
   ExcelFileName2=m_comboExc2.Select()+".txt";
 //  Print(i);
   if(m_combo0[i].Select()==maps[0]){
      if (m_combo00[i].Select()!="---") {
         if (m_combo1[i].Select()!="---") 
         
         {
   if (m_combo2[i].Select()=="Ингр.") 
   {
   if (m_combo3i[i].Select()!="Все")
   DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3i[i].Select(),m_combo0[i].Select(),"Новая папка\\allyr\\" + m_combo00[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
         else
         for (f=0;f<ArraySize(signsIngression);f++)
   DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), signsIngression[f],m_combo0[i].Select(),"Новая папка\\allyr\\" + m_combo00[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
       }      
       else      
            if (m_combo3[i].Select()!="---")
             DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\allyr\\" + m_combo00[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
               else
                 for (int y=1;y<ArraySize(planets);y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), planets[y],m_combo0[i].Select(),"Новая папка\\allyr\\" + m_combo00[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
}
 }  else
  { if (m_combo2[i].Select()=="Ингр.") 
   if (m_combo3i[i].Select()=="Все")
   for (int f1=0;f1<ArraySize(allyrfile);f1++)
      for (f=0;f<ArraySize(signsIngression);f++)
         DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), signsIngression[f],m_combo0[i].Select(),"Новая папка\\allyr\\" + allyrfile[f1],patternclr,m_combo6.Select(),m_combo7.Select(),i);
   else 
      for (int f1=0;f1<ArraySize(allyrfile);f1++)
         DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3i[i].Select(),m_combo0[i].Select(),"Новая папка\\allyr\\" + allyrfile[f1],patternclr,m_combo6.Select(),m_combo7.Select(),i);
         
   else
      for (f=0;f<ArraySize(allyrfile);f++)
   DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\allyr\\" + allyrfile[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);}
} else


    if(m_combo0[i].Select()==maps[1])
    {
      if (m_combo00p[i].Select()!="---") 
         if (m_combo1[i].Select()!="---") 
           if (m_combo3[i].Select()!="---")
                 if (m_combo3[i].Select()=="Все")
                        for (int y=0;y<ArraySize(natals)-1;y++) 
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\USA\\" + m_combo00p[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
                 else
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\USA\\"+ m_combo00p[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
               for (int y=1;y<ArraySize(planets);y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), planets[y],m_combo0[i].Select(),"Новая папка\\USA\\" + m_combo00p[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
         else
           if (m_combo3[i].Select()!="---")
                if (m_combo3[i].Select()!="Все")
                     for(int y=1;y<ArraySize(planets);y++) DrawFromExcel(planets[y],m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\USA\\" + m_combo00p[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
                     else
                     for (int y1=0;y1<ArraySize(natals);y1++) for(int y=1;y<ArraySize(planets);y++) DrawFromExcel(planets[y],m_combo2[i].Select(), natals[y1],m_combo0[i].Select(),"Новая папка\\USA\\" + m_combo00p[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
                 for(int y=1;y<ArraySize(planets);y++) for (int y1=1;y1<ArraySize(planets);y1++) DrawFromExcel(planets[y],m_combo2[i].Select(), planets[y1],m_combo0[i].Select(),"Новая папка\\USA\\" + m_combo00p[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
    else 
     if (m_combo3[i].Select()=="Все")
       for (f=0;f<ArraySize(usa);f++)  
         for (int y=0;y<ArraySize(natals)-1;y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\USA\\" + usa[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
      else
      
      
   for (f=0;f<ArraySize(usa);f++)
   if (m_combo1[i].Select()!="---") 
           if (m_combo3[i].Select()!="---")
                 if (m_combo3[i].Select()=="Все")
                        for (int y=0;y<ArraySize(natals)-1;y++) 
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\USA\\" + usa[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
                 else
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\USA\\"+ usa[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
               for (int y=1;y<ArraySize(planets);y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), planets[y],m_combo0[i].Select(),"Новая папка\\USA\\" + usa[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
         else
           if (m_combo3[i].Select()!="---")
                if (m_combo3[i].Select()!="Все")
                     for(int y=1;y<ArraySize(planets);y++) DrawFromExcel(planets[y],m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\USA\\" + usa[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
                     else
                     for (int y1=0;y1<ArraySize(natals);y1++) for(int y=1;y<ArraySize(planets);y++) DrawFromExcel(planets[y],m_combo2[i].Select(), natals[y1],m_combo0[i].Select(),"Новая папка\\USA\\" + usa[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
                 for(int y=1;y<ArraySize(planets);y++) for (int y1=1;y1<ArraySize(planets);y1++) DrawFromExcel(planets[y],m_combo2[i].Select(), planets[y1],m_combo0[i].Select(),"Новая папка\\USA\\" + usa[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
      
   }    
   
    if(m_combo0[i].Select()==maps[2]){
      if (m_combo00n[i].Select()!="---") 
         if (m_combo1[i].Select()!="---") 
            if (m_combo3[i].Select()!="---") 
                if (m_combo3[i].Select()=="Все")
                   for (int y=0;y<ArraySize(natals)-1;y++) 
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\Нефть\\" + m_combo00n[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
                else
                DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\Нефть\\"+m_combo00n[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
                     for (int y=1;y<ArraySize(planets);y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), planets[y],m_combo0[i].Select(),"Новая папка\\Нефть\\" + m_combo00n[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
             else
                 for(int y=1;y<ArraySize(planets);y++) for (int y1=1;y1<ArraySize(planets);y1++) DrawFromExcel(planets[y],m_combo2[i].Select(), planets[y1],m_combo0[i].Select(),"Новая папка\\Нефть\\" + m_combo00n[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
    else
         if (m_combo3[i].Select()=="Все")
       for (f=0;f<ArraySize(neft);f++)  
         for (int y=0;y<ArraySize(natals)-1;y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\Нефть\\" + neft[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
      else
      
      
      
      
   for (f=0;f<ArraySize(neft);f++)
   if (m_combo1[i].Select()!="---") 
           if (m_combo3[i].Select()!="---")
                 if (m_combo3[i].Select()=="Все")
                        for (int y=0;y<ArraySize(natals)-1;y++) 
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\Нефть\\" + neft[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
                 else
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\Нефть\\"+ neft[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
               for (int y=1;y<ArraySize(planets);y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), planets[y],m_combo0[i].Select(),"Новая папка\\Нефть\\" + neft[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
         else
           if (m_combo3[i].Select()!="---")
                if (m_combo3[i].Select()!="Все")
                     for(int y=1;y<ArraySize(planets);y++) DrawFromExcel(planets[y],m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\Нефть\\" + neft[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
                     else
                     for (int y1=0;y1<ArraySize(natals);y1++) for(int y=1;y<ArraySize(planets);y++) DrawFromExcel(planets[y],m_combo2[i].Select(), natals[y1],m_combo0[i].Select(),"Новая папка\\Нефть\\" + neft[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
                 for(int y=1;y<ArraySize(planets);y++) for (int y1=1;y1<ArraySize(planets);y1++) DrawFromExcel(planets[y],m_combo2[i].Select(), planets[y1],m_combo0[i].Select(),"Новая папка\\Нефть\\" + neft[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
      
   }    
    
    
    if(m_combo0[i].Select()==maps[3]){
      if (m_combo00g[i].Select()!="---") 
         if (m_combo1[i].Select()!="---") 
            if (m_combo3[i].Select()!="---") 
                if (m_combo3[i].Select()=="Все")
                   for (int y=0;y<ArraySize(natals)-1;y++) 
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\GOLD\\" + m_combo00g[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
                else
                DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\GOLD\\"+m_combo00g[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
                     for (int y=1;y<ArraySize(planets);y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), planets[y],m_combo0[i].Select(),"Новая папка\\GOLD\\" + m_combo00g[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
             else
                 for(int y=1;y<ArraySize(planets);y++) for (int y1=1;y1<ArraySize(planets);y1++) DrawFromExcel(planets[y],m_combo2[i].Select(), planets[y1],m_combo0[i].Select(),"Новая папка\\GOLD\\" + m_combo00g[i].Select(),patternclr,m_combo6.Select(),m_combo7.Select(),i);
    else
         if (m_combo3[i].Select()=="Все")
       for (f=0;f<ArraySize(gold);f++)  
         for (int y=0;y<ArraySize(natals)-1;y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\GOLD\\" + gold[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
      else
      
      
      
      
   for (f=0;f<ArraySize(gold);f++)
   if (m_combo1[i].Select()!="---") 
           if (m_combo3[i].Select()!="---")
                 if (m_combo3[i].Select()=="Все")
                        for (int y=0;y<ArraySize(natals)-1;y++) 
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), natals[y],m_combo0[i].Select(),"Новая папка\\GOLD\\" + gold[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
                 else
                        DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\GOLD\\"+ gold[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
               for (int y=1;y<ArraySize(planets);y++) DrawFromExcel(m_combo1[i].Select(),m_combo2[i].Select(), planets[y],m_combo0[i].Select(),"Новая папка\\GOLD\\" + gold[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
         else
           if (m_combo3[i].Select()!="---")
                if (m_combo3[i].Select()!="Все")
                     for(int y=1;y<ArraySize(planets);y++) DrawFromExcel(planets[y],m_combo2[i].Select(), m_combo3[i].Select(),m_combo0[i].Select(),"Новая папка\\GOLD\\" + gold[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
                     else
                     for (int y1=0;y1<ArraySize(natals);y1++) for(int y=1;y<ArraySize(planets);y++) DrawFromExcel(planets[y],m_combo2[i].Select(), natals[y1],m_combo0[i].Select(),"Новая папка\\GOLD\\" + gold[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
            else
                 for(int y=1;y<ArraySize(planets);y++) for (int y1=1;y1<ArraySize(planets);y1++) DrawFromExcel(planets[y],m_combo2[i].Select(), planets[y1],m_combo0[i].Select(),"Новая папка\\GOLD\\" + gold[f],patternclr,m_combo6.Select(),m_combo7.Select(),i);
      
   }  
    
    
    if ((m_combo0[i+1].Value()==m_combo0[i+2].Value())&&(m_combo00[i+1].Value()==m_combo00[i+2].Value())&&
    (m_combo00n[i+1].Value()==m_combo00n[i+2].Value())&&(m_combo00p[i+1].Value()==m_combo00p[i+2].Value())&&(m_combo00g[i+1].Value()==m_combo00g[i+2].Value())&&
    (m_combo3[i+1].Value()==m_combo3[i+2].Value())&&(m_combo3i[i+1].Value()==m_combo3i[i+2].Value())&&(m_combo2[i+1].Value()==m_combo2[i+2].Value())&&(m_combo1[i+1].Value()==m_combo1[i+2].Value())) break;  

   /* if(!UranusImport) {if(m_combo0[i].Value()=="Аллюр" && m_combo1[i].Value()!=0 && m_combo3[i].Value()!=0 && m_combo2[i].Value()!="Ингр.")AnalyzeAllure(m_combo1[i].Value(), m_combo3[i].Value(), StringToDouble(m_combo2[i].Select()), StringToDouble(m_combo4[i].Select()), patternclr, m_combo1[i].Select()+" "+m_combo2[i].Select()+" "+m_combo3[i].Select());}
    else
    { 
if(m_combo0[i].Select()==maps[0] && m_combo2[i].Select()!="Ингр.")UranusSearchAspect(m_combo1[i].Value(), m_combo3[i].Value(), StringToInteger(m_combo2[i].Select()), patternclr, m_combo1[i].Select()+" "+m_combo2[i].Select()+" "+m_combo3[i].Select());
if(m_combo1[i].Value()!=0 && m_combo2[i].Select()=="Ингр." && m_combo3i[i].Select()!="Все")UranusSearchIngression(m_combo1[i].Value(), m_combo3i[i].Value(), patternclr, m_combo1[i].Select()+" "+">"+" "+m_combo3i[i].Select());
//if(m_combo0[i].Select()==maps[1] && m_combo2[i].Select()!="Ингр.")UranusSearchTransit(m_combo1[i].Value(), m_combo3[i].Value(), StringToInteger(m_combo2[i].Select()), patternclr, "тр."+m_combo1[i].Select()+" "+m_combo2[i].Select()+" "+m_combo3[i].Select(), currtrans, Ptrans1, Ptrans2, asptrans, datetrans);
//if(m_combo0[i].Select()==maps[2] && m_combo2[i].Select()!="Ингр.")UranusSearchTransit(m_combo1[i].Value(), m_combo3[i].Value(), StringToInteger(m_combo2[i].Select()), patternclr, "дир."+m_combo1[i].Select()+" "+m_combo2[i].Select()+" "+m_combo3[i].Select(), currdir, Pdir1, Pdir2, aspdir, datedir);
//if(m_combo0[i].Select()==maps[3] && m_combo2[i].Select()!="Ингр.")UranusSearchTransit(m_combo1[i].Value(), m_combo3[i].Value(), StringToInteger(m_combo2[i].Select()), patternclr, "проф."+m_combo1[i].Select()+" "+m_combo2[i].Select()+" "+m_combo3[i].Select(), currprof, Pprof1, Pprof2, aspprof, dateprof);
//if(m_combo0[i].Select()==maps[4] && m_combo2[i].Select()!="Ингр.")UranusSearchTransit(m_combo1[i].Value(), m_combo3[i].Value(), StringToInteger(m_combo2[i].Select()), patternclr, "трет."+m_combo1[i].Select()+" "+m_combo2[i].Select()+" "+m_combo3[i].Select(), currtret, Ptret1, Ptret2, asptret, datetret);
//if(m_combo0[i].Select()==maps[5] && m_combo2[i].Select()!="Ингр.")UranusSearchTransit(m_combo1[i].Value(), m_combo3[i].Value(), StringToInteger(m_combo2[i].Select()), patternclr, "мин."+m_combo1[i].Select()+" "+m_combo2[i].Select()+" "+m_combo3[i].Select(), currmin, Pmin1, Pmin2, aspmin, datemin);

//if(m_combo1[i].Value()!=0 && m_combo2[i].Select()=="Ингр." && m_combo3i[i].Select()=="Все")for(int k=0; k<12; k++){Print(m_combo3i[i].Select()); UranusSearchIngression(m_combo1[i].Value(), k, patternclr, m_combo1[i].Select()+" "+">"+" "+signsIngression[k]);}

   } */ 
  /* ObjectsDeleteAll(ChartID(), 0, OBJ_ARROW);
   for (int n=0;n<ArraySize(casesasp);n++) for (int zy=0;zy<ArraySize(casesIng);zy++)
  if (MathAbs(int(datearr[casesasp[n]])-int(dateIng[casesIng[zy]]))<=5*86400) {Print(TimeToStr(datearr[casesasp[n]],TIME_DATE));DrawSymb(datearr[casesasp[n]], iHigh(NULL,NULL,iBarShift(NULL,0,datearr[casesasp[n]],true))*1.01, clrWhite, 108, "", "HELLO");}*/
  }   
  } 
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void TVpanel::OnClickButton2(void)
  {

  int excelsave=0;
  if (m_comboFil.Select()=="НЕТ")
     {if((StringGetCharacter(ExcelFileName, 1)==46) || (StringGetCharacter(ExcelFileName, 2)==46))
     excelsave=FileOpen(DirectoryNameS+"\\"+"Ш"+IntegerToString(globalcount)+".txt",FILE_WRITE|FILE_TXT|InpEncodingType);
     else excelsave=FileOpen(DirectoryNameS+"\\"+"Ш"+IntegerToString(globalcount)+".txt",FILE_WRITE|FILE_TXT|InpEncodingType);
     }else excelsave=FileOpen(DirectoryNameS+"\\"+FilterFileName,FILE_WRITE|FILE_TXT|InpEncodingType);
      
if(excelsave!=INVALID_HANDLE)
{                        
   //int objtot=ObjectsTotal(0,0, OBJ_ARROW); //Print(objtot);
   int count=NumberOfPatterns;
   for(int i=0; i<count; i++)
{   
   if (m_combo0[i].Value()==0)
   {
      if (m_combo2[i].Value()==5)
         FileWriteString(excelsave, m_combo0[i].Value()+"'"+m_combo00[i].Value()+"'"+m_combo1[i].Value()+"'"+m_combo2[i].Value()+"'"+m_combo3i[i].Value()+"\r\n");else
         FileWriteString(excelsave, m_combo0[i].Value()+"'"+m_combo00[i].Value()+"'"+m_combo1[i].Value()+"'"+m_combo2[i].Value()+"'"+m_combo3[i].Value()+"\r\n");}
   
   else 
      if (m_combo0[i].Value()==1)
   {
      if (m_combo2[i].Value()==5)
         FileWriteString(excelsave, m_combo0[i].Value()+"'"+m_combo00p[i].Value()+"'"+m_combo1[i].Value()+"'"+m_combo2[i].Value()+"'"+m_combo3i[i].Value()+"\r\n");else
         FileWriteString(excelsave, m_combo0[i].Value()+"'"+m_combo00p[i].Value()+"'"+m_combo1[i].Value()+"'"+m_combo2[i].Value()+"'"+m_combo3[i].Value()+"\r\n");}
   
   else 
      if (m_combo0[i].Value()==2)
   {
      if (m_combo2[i].Value()==5)
         FileWriteString(excelsave, m_combo0[i].Value()+"'"+m_combo00n[i].Value()+"'"+m_combo1[i].Value()+"'"+m_combo2[i].Value()+"'"+m_combo3i[i].Value()+"\r\n");else
         FileWriteString(excelsave, m_combo0[i].Value()+"'"+m_combo00n[i].Value()+"'"+m_combo1[i].Value()+"'"+m_combo2[i].Value()+"'"+m_combo3[i].Value()+"\r\n");}

      if (m_combo0[i].Value()==3)
   {
      if (m_combo2[i].Value()==5)
         FileWriteString(excelsave, m_combo0[i].Value()+"'"+m_combo00g[i].Value()+"'"+m_combo1[i].Value()+"'"+m_combo2[i].Value()+"'"+m_combo3i[i].Value()+"\r\n");else
         FileWriteString(excelsave, m_combo0[i].Value()+"'"+m_combo00g[i].Value()+"'"+m_combo1[i].Value()+"'"+m_combo2[i].Value()+"'"+m_combo3[i].Value()+"\r\n");}   
   
    if ((m_combo0[i+1].Value()==m_combo0[i+2].Value())&&(m_combo00[i+1].Value()==m_combo00[i+2].Value())&&
    (m_combo00n[i+1].Value()==m_combo00n[i+2].Value())&&(m_combo00p[i+1].Value()==m_combo00p[i+2].Value())&&(m_combo00g[i+1].Value()==m_combo00g[i+2].Value())&&
    (m_combo3[i+1].Value()==m_combo3[i+2].Value())&&(m_combo3i[i+1].Value()==m_combo3i[i+2].Value())&&(m_combo2[i+1].Value()==m_combo2[i+2].Value())&&(m_combo1[i+1].Value()==m_combo1[i+2].Value())) break;  
}
   
   globalcount++;
   int k=m_comboFil.Value();
   m_comboFil.ItemsClear();
   m_comboFil2.ItemsClear();
      string fname, ftype;
      int flength, i=0;
      long fsearch=FileFindFirst(DirectoryNameS+"\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist(DirectoryNameS + "\\" + fname)){
            flength=StringLen(fname); 
            ftype=StringSubstr(fname, flength-7, 3);//Print(StringSubstr(fname, flength-7, 3));}
            m_comboFil.AddItem(StringSubstr(fname, 0, flength-4), i);
            m_comboFil2.AddItem(StringSubstr(fname, 0, flength-4), i);
            i++;}
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);         
    m_comboFil.ItemInsert(0, "НЕТ", 0);
    m_comboFil.Select(k+1); 

   
   
}else ExtDialog.m_list_view.ItemInsert(0, "Не удается сохранить файл", 0);             
FileClose(excelsave);
  }
 //===================================================================
 void TVpanel::OnClickButton3(void)
  {
  ObjectsDeleteAll(ChartID(), 0, OBJ_ARROW);
  
  for(int i=0; i<NumberOfPatterns; i++)
  {
  m_combo0[i].Select(0);
  m_combo00[i].Select(0);
  m_combo00[i].Show();m_combo00n[i].Hide();m_combo00p[i].Hide();m_combo00g[i].Hide();
  m_combo00p[i].Select(0);
  m_combo00n[i].Select(0);
  m_combo1[i].Select(0);
  m_combo2[i].Select(0);
  m_combo3[i].Select(0);
  m_combo3[i].Show();m_combo3i[i].Hide();
  m_combo3i[i].Select(0);
  m_combo4[i].Select(0);
  m_combo5[i].Select(0);
  }
  m_list_view.ItemsClear();
  }
  
  
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void TVpanel::OnClickButton5(void)
  {
string newmass[5],newstr;
  int open=0,massnum,i2=0;

     open=FileOpen(DirectoryNameS+"\\"+FilterFileName2,FILE_READ|FILE_TXT|InpEncodingType);
      
if(open!=INVALID_HANDLE)
for(int i=0; !FileIsEnding(open); i++)
      {
      newstr=FileReadString(open); 

 massnum=StringSplit(newstr, 39, newmass);
//  m_combo1[i].Select(StringToInteger(newmass[0]));
//  m_combo2[i].Select(StringToInteger(newmass[1]));
//  if (newmass[1]=="5")
//  {m_combo3i[i].Show(); m_combo3i[i].Select(StringToInteger(newmass[2]));} else 
//  m_combo3[i].Select(StringToInteger(newmass[2]));
    
   int sizeP=ArraySize(planets); int sizeN=ArraySize(natals);

   
   if (newmass[0]!="0")for (int j=0; j<sizeN; j++) ExtDialog.m_combo3[i].AddItem(natals[j], sizeP+j);
       
    
    
   m_combo0[i].Select(StringToInteger(newmass[0]));
   if (newmass[0]=="0")
      {
      m_combo00n[i].Hide();
      m_combo00p[i].Hide();
      m_combo00g[i].Hide();
      m_combo00[i].Show();
      m_combo00[i].Select(StringToInteger(newmass[1]));
      }
   else
   if (newmass[0]=="1")
   {
      m_combo00n[i].Hide();
      m_combo00[i].Hide();
      m_combo00g[i].Hide();
      m_combo00p[i].Show();
      m_combo00p[i].Select(StringToInteger(newmass[1]));
   }   
   else
   if (newmass[0]=="2")
   {
      
      m_combo00p[i].Hide();
      m_combo00[i].Hide();
      m_combo00g[i].Hide();
      m_combo00n[i].Show();
      m_combo00n[i].Select(StringToInteger(newmass[1]));
   }
   else
   if (newmass[0]=="3")
   {
      m_combo00p[i].Hide();
      m_combo00[i].Hide();
      m_combo00n[i].Hide();
      m_combo00g[i].Show();
      m_combo00g[i].Select(StringToInteger(newmass[1]));
   }
   if (newmass[3]=="5")
      {
      m_combo1[i].Select(StringToInteger(newmass[2]));
      m_combo2[i].Select(StringToInteger(newmass[3]));
      m_combo3[i].Hide();
      m_combo3i[i].Show();m_combo3i[i].Select(StringToInteger(newmass[4]));
      } else
      {
      m_combo1[i].Select(StringToInteger(newmass[2]));
      m_combo2[i].Select(StringToInteger(newmass[3]));
      m_combo3i[i].Hide();
      m_combo3[i].Show();m_combo3[i].Select(StringToInteger(newmass[4]));
      
      
      }
 //   Print(newmass[0],newmass[1],newmass[2],newmass[3],newmass[4]);
    
  i2=i+1;
  m_list_view.ItemsClear();
  }else if (FilterFileName2=="НЕТ.txt") ExtDialog.m_list_view.ItemInsert(0, "Не удается открыть файл", 0);             
FileClose(open); 
  
open=FileOpen(DirectoryNameS+"\\"+FilterFileName,FILE_READ|FILE_TXT|InpEncodingType);
      if(open!=INVALID_HANDLE)
for(int i=i2; !FileIsEnding(open); i++)
      {
      newstr=FileReadString(open); 

 massnum=StringSplit(newstr, 39, newmass);
   m_combo0[i].Select(StringToInteger(newmass[0]));

   int sizeP=ArraySize(planets); int sizeN=ArraySize(natals);

   
   if (newmass[0]!="0")for (int j=0; j<sizeN; j++) ExtDialog.m_combo3[i].AddItem(natals[j], sizeP+j);
   
   
   
   
   m_combo0[i].Select(StringToInteger(newmass[0]));
   if (newmass[0]=="0")
      {
      m_combo00n[i].Hide();
      m_combo00p[i].Hide();
      m_combo00[i].Show();
      m_combo00[i].Select(StringToInteger(newmass[1]));
      }
   else
   if (newmass[0]=="1")
   {
      m_combo00n[i].Hide();
      
      m_combo00[i].Hide();
      m_combo00p[i].Show();
      m_combo00p[i].Select(StringToInteger(newmass[1]));
   }   
   else
   if (newmass[0]=="2")
   {
      
      m_combo00p[i].Hide();
      m_combo00[i].Hide();
      m_combo00n[i].Show();
      m_combo00n[i].Select(StringToInteger(newmass[1]));
   }
   if (newmass[3]=="5")
      {
      m_combo1[i].Select(StringToInteger(newmass[2]));
      m_combo2[i].Select(StringToInteger(newmass[3]));
      m_combo3[i].Hide();
      m_combo3i[i].Show();m_combo3i[i].Select(StringToInteger(newmass[4]));
      } else
      {
      m_combo1[i].Select(StringToInteger(newmass[2]));
      m_combo2[i].Select(StringToInteger(newmass[3]));
      m_combo3i[i].Hide();
      m_combo3[i].Show();m_combo3[i].Select(StringToInteger(newmass[4]));
      
      
      }
  
  m_list_view.ItemsClear();   // Print(newmass[0]+";"+newmass[1]+";"+newmass[2]+";"+newmass[3]+";"+newmass[4]);
  }
   
else if (FilterFileName2=="НЕТ.txt") ExtDialog.m_list_view.ItemInsert(0, "Не удается открыть файл", 0);             
FileClose(open);   


     }


  
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+

//| Event handler                                                    | 
//+------------------------------------------------------------------+ 
void TVpanel::OnChangeCheckGroup(void) 
  { 
   Comment(__FUNCTION__+" : Value="+IntegerToString(m_check_group.Value())); 
   //DrawFromAllur(m_comboTra.Select()+".txt",m_comboExc.Select()+".txt",m_comboExc2.Select()+".txt",m_combo6.Select(),m_combo7.Select(),m_combo8.Select(),m_check_group.Value(),m_check_group2.Value(),m_check_group1.Value(),m_check_group11.Value());
  } 
//+------------------------------------------------------------------+ 
void TVpanel::OnChangeCheckGroup1(void) 
  { 
   Comment(__FUNCTION__+" : Value1="+IntegerToString(m_check_group1.Value())); 
//   DrawFromAllur(m_comboTra.Select()+".txt",m_comboExc.Select()+".txt",m_comboExc2.Select()+".txt",m_combo6.Select(),m_combo7.Select(),m_combo8.Select(),m_check_group.Value(),m_check_group2.Value(),m_check_group1.Value(),m_check_group11.Value());
  } 
//+------------------------------------------------------------------+ 
void TVpanel::OnChangeCheckGroup2(void) 
  { 
   Comment(__FUNCTION__+" : Value2="+IntegerToString(m_check_group2.Value())); 
//   DrawFromAllur(m_comboTra.Select()+".txt",m_comboExc.Select()+".txt",m_comboExc2.Select()+".txt",m_combo6.Select(),m_combo7.Select(),m_combo8.Select(),m_check_group.Value(),m_check_group2.Value(),m_check_group1.Value(),m_check_group11.Value());
  } 
//+------------------------------------------------------------------+ 
void TVpanel::OnChangeCheckGroup11(void) 
  { 
   Comment(__FUNCTION__+" : Value11="+IntegerToString(m_check_group11.Value())); 
 //  DrawFromAllur(m_comboTra.Select()+".txt",m_comboExc.Select()+".txt",m_comboExc2.Select()+".txt",m_combo6.Select(),m_combo7.Select(),m_combo8.Select(),m_check_group.Value(),m_check_group2.Value(),m_check_group1.Value(),m_check_group11.Value());
  } 
//+------------------------------------------------------------------+ 

void TVpanel::OnClickButton4(void) 
  {        //Print(m_combo3i[0].Select());
      //ObjectsDeleteAll(ChartID(), 0, OBJ_ARROW);
      DrawFromAllur(m_comboTra.Select()+".txt",m_comboExc.Select()+".txt",m_comboExc2.Select()+".txt",m_combo6.Select(),m_combo7.Select(),m_combo8.Select(),m_check_group.Value(),m_check_group2.Value(),m_check_group1.Value(),m_check_group11.Value());
      }
      
void TVpanel::OnChangeComboboxExc(void)
{
 //Print(INIT_SUCCEEDED);
 if(!InitEnded)return;
//if(UranusTransitFileName==m_comboTra.Select())return;
 ExcelFileName=m_comboExc.Select()+".txt"; return;
}
//========================================================
void TVpanel::OnChangeComboboxExc2(void)
{
 //Print(INIT_SUCCEEDED);
 if(!InitEnded)return;
//if(UranusTransitFileName==m_comboTra.Select())return;
 ExcelFileName2=m_comboExc2.Select()+".txt"; return;
}
//========================================================

void TVpanel::OnChangeComboboxTra(void)
{
 //Print(INIT_SUCCEEDED);
 if(!InitEnded)return;
//if(UranusTransitFileName==m_comboTra.Select())return;

   UranusTransitFileName=m_comboTra.Select()+".txt";
   UranusDirectionFileName=m_comboTra.Select()+" DIR.txt";
   UranusProfectionFileName=m_comboTra.Select()+" PRO.txt";
   UranusTretichFileName=m_comboTra.Select()+" TRE.txt";
   UranusMinorFileName=m_comboTra.Select()+" MIN.txt";
   
   //Print(UranusTransitFileName, " ", UranusDirectionFileName," ", UranusProfectionFileName," ", UranusTretichFileName," ", UranusMinorFileName);
   
if(!ReadTransit(DirectoryName+"\\"+UranusTransitFileName, currtrans, Ptrans1, Ptrans2, asptrans, datetrans))ExtDialog.m_list_view.ItemInsert(0, "Нет файла с транзитами из Урануса "+UranusTransitFileName, 0);
ReadTransit(DirectoryName+"\\"+UranusDirectionFileName, currdir, Pdir1, Pdir2, aspdir, datedir);
ReadTransit(DirectoryName+"\\"+UranusProfectionFileName, currprof, Pprof1, Pprof2, aspprof, dateprof);
ReadTransit(DirectoryName+"\\"+UranusTretichFileName, currtret, Ptret1, Ptret2, asptret, datetret);
ReadTransit(DirectoryName+"\\"+UranusMinorFileName, currmin, Pmin1, Pmin2, aspmin, datemin);

}
//+------------------------------------------------------------------+
void TVpanel::OnChangeComboboxFilter(void)
{
 //Print(INIT_SUCCEEDED);
 if(!InitEnded)return;
//if(UranusTransitFileName==m_comboTra.Select())return;
 FilterFileName=m_comboFil.Select()+".txt"; return;
}
//========================================================
//+------------------------------------------------------------------+
void TVpanel::OnChangeComboboxFilter2(void)
{
 //Print(INIT_SUCCEEDED);
 if(!InitEnded)return;
//if(UranusTransitFileName==m_comboTra.Select())return;
 FilterFileName2=m_comboFil2.Select()+".txt"; return;
}
//=====================================================


//+------------------------------------------------------------------+
//| Rest events handler                                                    |
//+------------------------------------------------------------------+
bool TVpanel::OnDefault(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- restore buttons' states after mouse move'n'click
  // if(id==CHARTEVENT_CLICK)
     // ExtDialog.
    
//--- let's handle event by parent
   return(false);
  }
    
  bool TVpanel::Save(const int file_handle)
  {
     if(file_handle==INVALID_HANDLE)
      return(false);
    
 //   if(ArraySize(m_combo0)==0)return(false);
    
    for(int i=0; i<NumberOfPatterns; i++)
    {
    FileWriteLong(file_handle, m_combo0[i].Value());    
    FileWriteLong(file_handle, m_combo00[i].Value());    
    FileWriteLong(file_handle, m_combo00n[i].Value());    
    FileWriteLong(file_handle, m_combo00p[i].Value());    
    FileWriteLong(file_handle, m_combo00g[i].Value());      
    FileWriteLong(file_handle, m_combo1[i].Value());    
    FileWriteLong(file_handle, m_combo2[i].Value());  
      FileWriteLong(file_handle, m_combo3[i].Value());
            FileWriteLong(file_handle, m_combo3i[i].Value());
      FileWriteLong(file_handle, m_combo4[i].Value());
      FileWriteLong(file_handle, m_combo5[i].Value());      
      }

     //FileWriteLong(file_handle, m_list_view.SelectByValue(1));
      
            return(true);
  }
  
  bool TVpanel::Load(const int file_handle)
  {
     if(file_handle==INVALID_HANDLE)
      return(false);
        
    for(int i=0; i<NumberOfPatterns; i++)
    {
     m_combo0[i].SelectByValue(FileReadLong(file_handle));
     m_combo00[i].SelectByValue(FileReadLong(file_handle));
     m_combo00n[i].SelectByValue(FileReadLong(file_handle));
     m_combo00p[i].SelectByValue(FileReadLong(file_handle));
    m_combo1[i].SelectByValue(FileReadLong(file_handle));    
    m_combo2[i].SelectByValue(FileReadLong(file_handle));    
      m_combo3[i].SelectByValue(FileReadLong(file_handle));    
      m_combo3i[i].SelectByValue(FileReadLong(file_handle));    
      m_combo4[i].SelectByValue(FileReadLong(file_handle));    
      m_combo5[i].SelectByValue(FileReadLong(file_handle));    
      } 
        
      return(true);
  }

//+------------------------------------------------------------------+
   
   TVpanel ExtDialog;
//------------------------------------------------------------------------

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() 
  {InitEnded=false;
  
  

         string fname, ftype;
//      int flength;
      int i=0;
      long fsearch=FileFindFirst("Новая папка\\allyr\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist("Новая папка\\allyr\\" + fname)){
         ArrayResize(allyrfile, i+1, 20000);
            allyrfile[i]=fname;
             
           // Print(allyrfile[i]);
            
            i++;  }
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);         
   i=0;
  fsearch=FileFindFirst("Новая папка\\Нефть\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist("Новая папка\\Нефть\\" + fname)){
         ArrayResize(neft, i+1, 20000);
            neft[i]=fname;
             
          //  Print(neft[i]);
            
            i++;  }
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);
  i=0;
  fsearch=FileFindFirst("Новая папка\\USA\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist("Новая папка\\USA\\" + fname)){
         ArrayResize(usa, i+1, 20000);
            usa[i]=fname;
             
         //   Print(usa[i]);
            
            i++;  }
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);

   i=0;
  fsearch=FileFindFirst("Новая папка\\GOLD\\*", fname);
      if(fsearch!=INVALID_HANDLE)
         do{
         if(FileIsExist("Новая папка\\GOLD\\" + fname)){
         ArrayResize(gold, i+1, 20000);
            gold[i]=fname;
             
          //  Print(neft[i]);
            
            i++;  }
            }while(FileFindNext(fsearch, fname));
     FileFindClose(fsearch);
       



   if(ALLURE_ANALYSYS)
   { 
   long chartwidth=0;
   ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0, chartwidth);     
   ExtDialog.Create(0,"Allure Analysis",0, (int)chartwidth-500, 0,(int)chartwidth,NumberOfPatterns*(COMBO_HEIGHT+CONTROLS_GAP_Y)+2*BUTTON_HEIGHT+INDENT_TOP+80);
    

  if(!ExtDialog.Run())
     return(INIT_FAILED); 
     
    int loadfile=FileOpen(IntegerToString(NumberOfPatterns)+"TransitView1.4.dat", FILE_READ|FILE_BIN, InpEncodingType);
    if(loadfile!=INVALID_HANDLE)
    {
  ExtDialog.Load(loadfile);
  FileClose(loadfile);
    }
     }
     
//тут посмотри   ChartSetSymbolPeriod(ChartID(), ChartSymbol(0), PERIOD_H4);
   ChartSetInteger(ChartID(), CHART_AUTOSCROLL, false);   
   ChartSetInteger(ChartID(),CHART_SHOW_OBJECT_DESCR, true);
   ChartSetInteger(ChartID(), CHART_WINDOW_YDISTANCE, 0, 100);
  //Print( ChartGetInteger(0, CHART_WINDOW_YDISTANCE, 0));
//   ChartSetInteger(ChartID(), CHART_COLOR_BACKGROUND, clrBlack);
//   ChartSetInteger(ChartID(), CHART_MODE, CHART_CANDLES); 
//   ChartSetInteger(ChartID(), CHART_COLOR_CHART_LINE, clrLime); 
//   ChartSetInteger(ChartID(), CHART_COLOR_CANDLE_BULL, clrLime); 
//   ChartSetInteger(ChartID(), CHART_COLOR_CANDLE_BEAR, clrLime); 
//   ChartSetInteger(ChartID(), CHART_COLOR_CHART_UP, clrLime); 
//   ChartSetInteger(ChartID(), CHART_COLOR_CHART_DOWN, clrLime); 
     
 bool ShowME=ShowMercury;
 bool ShowSU=ShowSun;
 bool ShowL=ShowMoon;
 bool ShowV=ShowVenus;
 bool ShowMA=ShowMars;
 bool ShowJ=ShowJupiter;
 bool ShowSA=ShowSaturn;
 bool ShowU=ShowUranus;
 bool ShowN=ShowNeptune;
 bool ShowP=ShowPluto;
 
if(OnlyFast)
{
 ShowME=true;
 ShowSU=true;
 ShowL=false;
 ShowV=true;
 ShowMA=true;
 ShowJ=false;
 ShowSA=false;
 ShowU=false;
 ShowN=false;
 ShowP=false;
}

if(!UranusImport)
{
   natal=FileOpen(DirectoryName+"\\"+NatalFileName,FILE_READ|FILE_TXT|InpEncodingType);
if(natal!=INVALID_HANDLE)
{
    SU=GetDegree(natal, "P"); 
    L=GetDegree(natal, "P"); 
    ME=GetDegree(natal, "P"); 
    V=GetDegree(natal, "P"); 
    MA=GetDegree(natal, "P"); 
    J=GetDegree(natal, "P"); 
    SA=GetDegree(natal, "P"); 
    U=GetDegree(natal, "P"); 
    N=GetDegree(natal, "P"); 
    P=GetDegree(natal, "P"); 
    FileReadString(natal);  
    FileReadString(natal);  
    H1=GetDegree(natal, "H");  
    H2=GetDegree(natal, "H"); 
    H3=GetDegree(natal, "H"); 
    H4=GetDegree(natal, "H"); 
    H5=GetDegree(natal, "H"); 
    H6=GetDegree(natal, "H"); 
    H7=GetDegree(natal, "H"); 
    H8=GetDegree(natal, "H"); 
    H9=GetDegree(natal, "H"); 
    H10=GetDegree(natal, "H"); 
    H11=GetDegree(natal, "H"); 
    H12=GetDegree(natal, "H"); 
    
    FileClose(natal);
}else Comment("Нет файла с натальной картой Table.txt");
}
      
   datetime date; 
   double pricedata[1]; pricedata[0]=0;
   double pricedataL[1];pricedataL[0]=0;
   double pricedataH[1];pricedataH[0]=0;
   int copy, copyL, copyH;
   MqlDateTime str;
      
   i=0; string newstr;
   
  // if(ExcelImport){InitEnded=true; return(INIT_SUCCEEDED);}                  
   
   if(!UranusImport || !ALLURE_ANALYSYS)  //РАССЧИТЫВАЕМ ИЗ ЭФЕМЕРИД
   {
   if(ArraySize(degJ)==0)
   {
   ArrayResize(curr, 11000, 20000);
   ArrayResize(degSU, 11000, 20000);
   ArrayResize(degL, 11000, 20000);
   ArrayResize(degME, 11000, 20000);
   ArrayResize(degV, 11000, 20000);
   ArrayResize(degMA, 11000, 20000);
   ArrayResize(degJ, 11000, 20000);
   ArrayResize(degSA, 11000, 20000);
   ArrayResize(degU, 11000, 20000);
   ArrayResize(degN, 11000, 20000);
   ArrayResize(degP, 11000, 20000);
   ArrayResize(Pone, 11000, 20000);
   ArrayResize(Ptwo, 11000, 20000); 
   
   int efemer=FileOpen(DirectoryName+"\\"+TransitFileName,FILE_READ|FILE_TXT|InpEncodingType);
 if(efemer!=INVALID_HANDLE)
 {
   FileReadString(efemer); 
   FileReadString(efemer); 
   FileReadString(efemer);
    
   for(i=0; !FileIsEnding(efemer); i++)
   {
   ArrayResize(curr, i+10, 20000);
   ArrayResize(degSU, i+10, 20000);
   ArrayResize(degL, i+10, 20000);
   ArrayResize(degME, i+10, 20000);
   ArrayResize(degV, i+10, 20000);
   ArrayResize(degMA, i+10, 20000);
   ArrayResize(degJ, i+10, 20000);
   ArrayResize(degSA, i+10, 20000);
   ArrayResize(degU, i+10, 20000);
   ArrayResize(degN, i+10, 20000);
   ArrayResize(degP, i+10, 20000);
   ArrayResize(Pone, i+10, 20000);
   ArrayResize(Ptwo, i+10, 20000); 

   curr[i]=FileReadString(efemer);
   degSU[i]=StringToDouble(StringSubstr(curr[i], 21, 9));
   degL[i]=StringToDouble(StringSubstr(curr[i], 32, 9));
   degME[i]=StringToDouble(StringSubstr(curr[i], 43, 9));
   degV[i]=StringToDouble(StringSubstr(curr[i], 54, 9));
   degMA[i]=StringToDouble(StringSubstr(curr[i], 65, 9));
   degJ[i]=StringToDouble(StringSubstr(curr[i], 76, 9));
   degSA[i]=StringToDouble(StringSubstr(curr[i], 87, 9));
   degU[i]=StringToDouble(StringSubstr(curr[i], 98, 9));
   degN[i]=StringToDouble(StringSubstr(curr[i], 109, 9));
   degP[i]=StringToDouble(StringSubstr(curr[i], 120, 9));
   }
   FileClose(efemer); // Print("INI"); //Print(ArrayRange(degJ, 0), " ", ArraySize(curr));
}else Comment ("Нет файла с эфемеридами Ephemerides.txt");
   } 
   }
   else  //ИМПОРТИРУЕМ ИЗ УРАНУСА
   { 
   if(!ReadTransit(DirectoryName+"\\"+UranusAllureFileName, curr, Pname1, Pname2, asp, datearr))ExtDialog.m_list_view.ItemInsert(0, "Нет файла с аспектами из Урануса uranus.txt", 0);
   // Print(curr[20]);Print(curr[21]);Print(curr[22]);
    /*  int uranimp=FileOpen(UranusAllureFileName,FILE_READ|FILE_TXT|InpEncodingType);
if(uranimp!=INVALID_HANDLE)
{
      FileReadString(uranimp);
      FileReadString(uranimp);
      FileReadString(uranimp);
      FileReadString(uranimp);
            
      for(i=0; !FileIsEnding(uranimp); i++)
      {
      newstr=FileReadString(uranimp);if(newstr==""){i--; continue;}
 
            ArrayResize(curr, i+1, 20000);
            ArrayResize(Pname1, i+1, 20000);
            ArrayResize(Pname2, i+1, 20000); 
            ArrayResize(asp, i+1, 20000);
            ArrayResize(datearr, i+1, 20000);
  
   curr[i]=newstr;
   datearr[i]=StringToTime(StringSubstr(curr[i], 1, 10)+StringSubstr(curr[i], 11, 6));
   Pname1[i]=StringSubstr(curr[i], 23, 3);
   Pname2[i]=StringSubstr(curr[i], 27, 3);
   asp[i]=StringToInteger(StringSubstr(curr[i], 40, 3));
      }
     FileClose(uranimp); //Print(asp[500], "\\\\");
}else ExtDialog.m_list_view.ItemInsert(0, "Нет файла с аспектами из Урануса uranus.txt",0);*/
   
   
///ИНГРЕССИИ ИЗ УРАНУСА
      int uranIngr=FileOpen(DirectoryName+"\\"+UranusIngressionFileName,FILE_READ|FILE_TXT|InpEncodingType);
if(uranIngr!=INVALID_HANDLE)
{

newstr=FileReadString(uranIngr);
for(int i1=0; StringToInteger(StringSubstr(newstr, 0, 3))==0; i1++)newstr=FileReadString(uranIngr);                       
            
      for(i=0; !FileIsEnding(uranIngr); i++)
      {
      if(newstr==""){i--; continue;}
 
            ArrayResize(currIng, i+1, 20000);
            ArrayResize(PnameIng, i+1, 20000);
            ArrayResize(signIng, i+1, 20000);
            ArrayResize(dateIng, i+1, 20000);
   
   currIng[i]=newstr;
   if(StringSubstr(currIng[i], 0, 1)!=" ") //для старого Урануса
   {
   dateIng[i]=StringToTime(StringSubstr(currIng[i], 0, 10)+StringSubstr(currIng[i], 10, 6));
   PnameIng[i]=StringSubstr(currIng[i], 21, 3);
   signIng[i]=StringSubstr(currIng[i], 30, 8);
   }else
   {
   dateIng[i]=StringToTime(StringSubstr(currIng[i], 1, 10)+StringSubstr(currIng[i], 11, 6));
   PnameIng[i]=StringSubstr(currIng[i], 21, 3);
   signIng[i]=StringSubstr(currIng[i], 30, 8);
   }
   
   newstr=FileReadString(uranIngr);if(newstr=="")break;
      }
     FileClose(uranIngr);// Print(ArraySize(currIng), "  ",dateIng[629], " ", PnameIng[629], " ", signIng[629]);
}else ExtDialog.m_list_view.ItemInsert(0, "Нет файла с ингрессиями из Урануса uranus ingr.txt", 0);

//ТРАНЗИТЫ ИЗ УРАНУСА
/*if(!ReadTransit(DirectoryName+"\\"+UranusTransitFileName, currtrans, Ptrans1, Ptrans2, asptrans, datetrans))ExtDialog.m_list_view.ItemInsert(0, "Нет файла с транзитами из Урануса "+UranusTransitFileName, 0);
if(!ReadTransit(DirectoryName+"\\"+UranusDirectionFileName, currdir, Pdir1, Pdir2, aspdir, datedir))ExtDialog.m_list_view.ItemInsert(0, "Нет файла с дирекцией из Урануса "+UranusDirectionFileName, 0);
if(!ReadTransit(DirectoryName+"\\"+UranusProfectionFileName, currprof, Pprof1, Pprof2, aspprof, dateprof))ExtDialog.m_list_view.ItemInsert(0, "Нет файла с профекцией из Урануса "+UranusProfectionFileName, 0);
if(!ReadTransit(DirectoryName+"\\"+UranusTretichFileName, currtret, Ptret1, Ptret2, asptret, datetret))ExtDialog.m_list_view.ItemInsert(0, "Нет файла с третичной прогрессией из Урануса "+UranusTretichFileName, 0);
if(!ReadTransit(DirectoryName+"\\"+UranusMinorFileName, currmin, Pmin1, Pmin2, aspmin, datemin))ExtDialog.m_list_view.ItemInsert(0, "Нет файла с минорной прогрессией из Урануса uranus "+UranusMinorFileName, 0);*/
}

   /*   int uranTrans=FileOpen(UranusTransitFileName,FILE_READ|FILE_TXT|InpEncodingType);
if(uranTrans!=INVALID_HANDLE)
{
      newstr=FileReadString(uranTrans);
      for(i=0; StringToInteger(StringSubstr(newstr, 0, 3))==0; i++)newstr=FileReadString(uranTrans);
            
      for(i=0; !FileIsEnding(uranTrans); i++)
      {     
            ArrayResize(currtrans, i+1, 20000);
            ArrayResize(Ptrans1, i+1, 20000);
            ArrayResize(Ptrans2, i+1, 20000);
            ArrayResize(asptrans, i+1, 20000);
            ArrayResize(datetrans, i+1, 20000);
   
   currtrans[i]=newstr;
   datetrans[i]=StringToTime(StringSubstr(currtrans[i], 1, 10)+StringSubstr(currtrans[i], 11, 6));
   Ptrans1[i]=StringSubstr(currtrans[i], 23, 3);
   Ptrans2[i]=StringSubstr(currtrans[i], 27, 3);
   asptrans[i]=StringToInteger(StringSubstr(currtrans[i], 40, 3));
   
   newstr=FileReadString(uranTrans);if(newstr=="")break;
      }
     FileClose(uranTrans); //Print(ArraySize(currtrans), "  ",Ptrans1[5006], Ptrans2[5006]);
}else ExtDialog.m_list_view.ItemInsert(0, "Нет файла с транзитами из Урануса uranus trans.txt", 0); */
 InitEnded=true;
if(ALLURE_ANALYSYS)return(INIT_SUCCEEDED);

    ObjectsDeleteAll(ChartID(), 0, OBJ_ARROW);
    ObjectsDeleteAll(ChartID(), 0, OBJ_LABEL);

   int size=ArraySize(degJ); //Print(size);// return(INIT_SUCCEEDED);
   for(int k=0; degJ[k]>0; k++) 
   {   
   date=StringToTime(StringSubstr(curr[k+1], 0, 10)); 
   TimeToStruct(date, str);
   if(str.day_of_week==0)date+=86400;
   if(str.day_of_week==6)date-=86400; 
    
   copy=CopyClose(ChartSymbol(0), PERIOD_H4, date, 1, pricedata);
   if(copy<0)copy=CopyClose(ChartSymbol(0), PERIOD_D1, date, 1, pricedata);
   copyL=CopyLow(ChartSymbol(0), PERIOD_H4, date, 1, pricedataL);
   if(copyL<0)copyL=CopyLow(ChartSymbol(0), PERIOD_D1, date, 1, pricedataL);
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, date, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, date, 1, pricedataH);
    
   if(fstmult==1.1 && pricedataH[0]<pricedataL[0] && !OnlyFast)
   {pricedataH[0]=pricedataL[0]; 
   copyL=(int)CopyHigh(ChartSymbol(0), PERIOD_H4, date, 1, pricedataL);
   fstmult=1.2; sndmult=1.4;
  // if(priceshift==0)priceshift=ChartGetDouble(ChartID(), CHART_PRICE_MAX, 0); Print(priceshift);
   } 
   if(pricedataH[0]<pricedataL[0] && !OnlyFast){fstmult=1.05; sndmult=1.1;}
 
   if((copy>0 || date>TimeCurrent()) && ShowSU)
   {
   sizeshift=0; pcurr="Sun";
   CheckPlanet(degSU[k], degSU[k+1], degSU[k+2], pricedata[0], date, pcurr);
   } 
   
   if((copyL>0 || date>TimeCurrent())&& ShowL)
   {
   sizeshift=0.01; pcurr="Moon";
   CheckPlanet(degL[k], degL[k+1], degL[k+2], pricedataL[0]*(2-fstmult), date, pcurr);
   } 
   
   if((copyL>0 || date>TimeCurrent())&& ShowV)
   { 
   sizeshift=2.01; pcurr="Venus";
   CheckPlanet(degV[k], degV[k+1], degV[k+2], pricedataL[0]*(2-sndmult), date, pcurr);
   } 
   
   if((copyH>0 || date>TimeCurrent())&& ShowME)
   {
   sizeshift=0.02; pcurr="Mercury";
   CheckPlanet(degME[k], degME[k+1], degME[k+2], pricedataH[0]*fstmult, date, pcurr);
   } 
   
   if((copyH>0 || date>TimeCurrent())&& ShowMA)
   {
   sizeshift=2.02; pcurr="Mars";
   CheckPlanet(degMA[k], degMA[k+1], degMA[k+2], pricedataH[0]*sndmult, date, pcurr);
   } 
   
   if((copy>0 || date>TimeCurrent())&& ShowJ)
   {
   sizeshift=0; pcurr="Jupiter";
   CheckPlanet(degJ[k], degJ[k+1], degJ[k+2], pricedata[0], date, pcurr);
   } 
   
   if((copyL>0 || date>TimeCurrent())&& ShowSA)
   {
   sizeshift=0.01; pcurr="Saturn";
   CheckPlanet(degSA[k], degSA[k+1], degSA[k+2], pricedataL[0]*(2-fstmult), date, pcurr);
   } 
   
   if((copyL>0 || date>TimeCurrent())&& ShowU)
   { 
   sizeshift=2.01; pcurr="Uranus";
   CheckPlanet(degU[k], degU[k+1], degU[k+2], pricedataL[0]*(2-sndmult), date, pcurr);
   } 
   
   if((copyH>0 || date>TimeCurrent())&& ShowN)
   {
   sizeshift=0.02; pcurr="Neptune";
   CheckPlanet(degN[k], degN[k+1], degN[k+2], pricedataH[0]*fstmult, date, pcurr);
   } 
   
   if((copyH>0 || date>TimeCurrent())&& ShowP)
   {
   sizeshift=2.02; pcurr="Pluto";
   CheckPlanet(degP[k], degP[k+1], degP[k+2], pricedataH[0]*sndmult, date, pcurr);
   } 
   }
   
   if(ShowSU)DrawLabel("SU", "Sun", TimeCurrent()-25000000, pricedata[0]);
   if(ShowL)DrawLabel("L", "Moon", TimeCurrent()-35000000, pricedataL[0]*(2-fstmult));
   if(ShowV)DrawLabel("V", "Venus", TimeCurrent()-50000000, pricedataL[0]*(2-sndmult));
   if(ShowME)DrawLabel("ME", "Mercury", TimeCurrent()-35000000,  pricedataH[0]*fstmult);
   if(ShowMA)DrawLabel("MA", "Mars", TimeCurrent()-50000000, pricedataH[0]*sndmult);
 
   if(ShowJ)DrawLabel("J", "Jupiter", TimeCurrent()-2500000, pricedata[0]);
   if(ShowSA)DrawLabel("SA", "Saturn", TimeCurrent()-6000000, pricedataL[0]*(2-fstmult));
   if(ShowU)DrawLabel("U", "Uranus", TimeCurrent()-9000000, pricedataL[0]*(2-sndmult));
   if(ShowN)DrawLabel("N", "Neptune", TimeCurrent()-6000000,  pricedataH[0]*fstmult);
   if(ShowP)DrawLabel("P", "Pluto", TimeCurrent()-9000000, pricedataH[0]*sndmult);
 
   return(INIT_SUCCEEDED); 
   

   
   
  }
//- 
  
  bool DrawSymb(datetime dt, double price, color clr, int code, string asp, string planet)
  {
  
   if(MathAbs(prevdate-dt)<86400 && prevprice==price)
   {
   pricedraw*=1.015;
  // if(OnlyFast)pricedraw=price*1.05;
   }else pricedraw=price;
    
    string symb; 
     
     if(ALLURE_ANALYSYS)symb=planet+" / "+TimeDay(dt)+"."+TimeMonth(dt)+"."+TimeYear(dt)+" "+TimeHour(dt)+":"+StringFormat("%02d",TimeMinute(dt));
     else symb=planet+asp+"/"+dt+"/"+clr+"/"+IntegerToString(numobj);
      //ObjectSetString(ChartID(), symb, OBJPROP_TOOLTIP, planet+"/"+dt);
    ObjectCreate(ChartID(), symb, OBJ_ARROW, 0, dt, pricedraw);
    ObjectSetInteger(ChartID(),symb,OBJPROP_ARROWCODE,code); 
       ObjectSetInteger(ChartID(), symb,OBJPROP_COLOR, clr); 
      ObjectSetInteger(ChartID(),symb,OBJPROP_BACK, false); 
       //if(ALLURE_ANALYSYS)ObjectSetInteger(ChartID(),symb,OBJPROP_BACK, true); 
        //ObjectSetInteger(ChartID(),symb,OBJPROP_SELECTABLE,false);
        ObjectSetInteger(ChartID(), symb,OBJPROP_WIDTH,1+sizeshift); 
        if(code==169)ObjectSetInteger(ChartID(), symb,OBJPROP_WIDTH,3+sizeshift);
       //if(code==118)ObjectSetInteger(ChartID(), symb,OBJPROP_WIDTH,2);
    // if(clr==clrKhaki && sizeshift==2.01) Print(dt, pricedraw);
 
       //ArrayResize(datearr, numobj+10, 5000);
     //  int range=ArrayRange(datearr, 0) + 1;
     //datearr[numobj]=symb;
     numobj++;
     
     prevdate=dt; prevprice=price;
  
  return(true);
  } 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
     return(rates_total);
  }
//---------------------------------------------------------
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   ExtDialog.ChartEvent(id,lparam,dparam,sparam);
   
   if(id==CHARTEVENT_OBJECT_CLICK) 
   {
   string clickedChartObject=sparam; //Print(StringSubstr(clickedChartObject, 12, 8));

if(StringSubstr(clickedChartObject, 5, 6)=="Combo2" && (StringSubstr(clickedChartObject, 12, 8)=="ListItem" || StringSubstr(clickedChartObject, 13, 8)=="ListItem"))
{  //прячем окно с планетами и показываем со знаками при клике на "Ингр."
   int i=(int)StringToInteger(StringSubstr(clickedChartObject, 11, 2));// Print(clickedChartObject);
   if(clickedChartObject==ExtDialog.Name()+"Combo2"+(string)i+"ListItem5"){ExtDialog.m_combo3[i].Hide(); ExtDialog.m_combo3i[i].Show();}
   else {ExtDialog.m_combo3i[i].Hide();ExtDialog.m_combo3[i].Show(); }
 }  
 
 if(StringSubstr(clickedChartObject, 5, 6)=="Combo0" && (StringSubstr(clickedChartObject, 12, 8)=="ListItem" || StringSubstr(clickedChartObject, 13, 8)=="ListItem"))
{
   int i=(int)StringToInteger(StringSubstr(clickedChartObject, 11, 2)); //Print(clickedChartObject);
   int sizeP=ArraySize(planets); int sizeN=ArraySize(natals);
   if(clickedChartObject==ExtDialog.Name()+"Combo0"+(string)i+"ListItem0") {
   
   if(ExtDialog.m_combo3[i].SelectByValue(sizeP))for (int j=0; j<sizeN; j++)ExtDialog.m_combo3[i].ItemDelete(sizeP); }
   else {if(!ExtDialog.m_combo3[i].SelectByValue(sizeP))for (int j=0; j<sizeN; j++)ExtDialog.m_combo3[i].AddItem(natals[j], sizeP+j);}
   int j=StringToInteger(StringSubstr(clickedChartObject, StringLen(clickedChartObject)-1, 1)); 
 //  Print(i);
   if (j==0){ExtDialog.m_combo00[i].Show(); ExtDialog.m_combo00p[i].Hide();ExtDialog.m_combo00n[i].Hide();ExtDialog.m_combo00g[i].Hide();Print("hi");};
   if (j==1){ExtDialog.m_combo00[i].Hide(); ExtDialog.m_combo00p[i].Show();ExtDialog.m_combo00n[i].Hide();ExtDialog.m_combo00g[i].Hide();Print("hi2");};
   if (j==2){ExtDialog.m_combo00[i].Hide(); ExtDialog.m_combo00p[i].Hide();ExtDialog.m_combo00n[i].Show();ExtDialog.m_combo00g[i].Hide();Print("hi3");};
   if (j==3){ExtDialog.m_combo00[i].Hide(); ExtDialog.m_combo00p[i].Hide();ExtDialog.m_combo00n[i].Hide();ExtDialog.m_combo00g[i].Show();Print("hi4");};
 }   
 
 
   }
    
  } 
//--- return value of prev_calculated for next call

  
  void OnDeinit(const int reason)
  {InitEnded=false;
 // ArrayFree(curr);ArrayFree(degSU);ArrayFree(degL);ArrayFree(degME);ArrayFree(degV);ArrayFree(degMA);ArrayFree(degJ);ArrayFree(degSA);ArrayFree(degU);ArrayFree(degN);ArrayFree(degP);ArrayFree(Pone);ArrayFree(Ptwo);
  if(ALLURE_ANALYSYS)
  {
  int savefile=FileOpen(IntegerToString(NumberOfPatterns)+"TransitView1.4.dat", FILE_WRITE|FILE_BIN, InpEncodingType);
  if(savefile!=INVALID_HANDLE)
  {
  ExtDialog.Save(savefile);
  FileClose(savefile);
  } 
   ExtDialog.Destroy(reason);
   }
  
  if(reason!=3)for(int i=0; i<ArraySize(datearr); i++)ObjectDelete(ChartID(), datearr[i]);

//
  //ChartRedraw();
  }
   
  //=================================================
  
  //==============================================
    double GetDegree(int file, string switcher)
{
   double d=0;
   string sign;
   int i;
   string natalstring=FileReadString(file);
   if(switcher=="P"){
   d=StringToDouble(StringSubstr(natalstring, 10, 2))+StringToDouble(StringSubstr(natalstring, 13, 2))/60+StringToDouble(StringSubstr(natalstring, 16, 2))/3600; 
   sign=StringSubstr(natalstring, 22, 3);}
   if(switcher=="H"){
   for(i=0; (ushort)StringGetCharacter(natalstring, i)!=9 && i<30; i++);
   d=StringToDouble(StringSubstr(natalstring, i+1, 2))+StringToDouble(StringSubstr(natalstring, i+4, 2))/60+StringToDouble(StringSubstr(natalstring, i+7, 2))/3600; 
   sign=StringSubstr(natalstring, i+13, 3);}

   if(sign=="Tau")d=d+30;
   if(sign=="Gem")d=d+60;
   if(sign=="Cnc")d=d+90;
   if(sign=="Leo")d=d+120;
   if(sign=="Vir")d=d+150;
   if(sign=="Lib")d=d+180;
   if(sign=="Sco")d=d+210;
   if(sign=="Sgr")d=d+240;
   if(sign=="Cap")d=d+270;
   if(sign=="Aqr")d=d+300;
   if(sign=="Psc")d=d+330;
   
  // if(switcher=="P"){nataldegs[nattimer]=d; nattimer++;}
  // if(switcher=="H"){housedegs[housetimer]=d; housetimer++;}

  return(d); 
  }









  
  void CheckAspect(double deg1, double deg2, double deg3, double natdeg, double price, datetime date, color clr, string pcurr)
  {
  /*
  double d;
  
  double deg1dec=deg1/10-MathFloor(deg1/10);
  double deg2dec=deg2/10-MathFloor(deg2/10);
  double deg3dec=deg3/10-MathFloor(deg3/10);
  double natdegdec=natdeg/10-MathFloor(natdeg/10);
  
  double d1=MathAbs(deg1dec-natdegdec);
  double d2=MathAbs(deg2dec-natdegdec);
  double d3=MathAbs(deg3dec-natdegdec);
   
  if(d2<d1 && d2<d3)d=NormalizeDouble(deg2,0); else return;
  natdeg=NormalizeDouble(natdeg, 0);
  //if(sizeshift==2.02)Print(deg2, date, clr, U, " ", P," ", J);
  
   if(d==natdeg)DrawSymb(date, price, clr, 108, "*0*");
   if(MathAbs(d-natdeg)==90 || MathAbs(d-natdeg)==270)DrawSymb(date, price, clr, 110, "*90*");
   if(MathAbs(d-natdeg)==120 || MathAbs(d-natdeg)==240)DrawSymb(date, price, clr, 169, "*120*");
   if(MathAbs(d-natdeg)==180)DrawSymb(date, price, clr, 118, "*180*");
  */ 
  double allureorb=0;
  bool exact=false, pivot=false;
  
   double allureasp=0;
   double currasp=MathAbs(deg2-natdeg); 
   double prevasp=MathAbs(deg1-natdeg);
   double nextasp=MathAbs(deg3-natdeg); 
   pivot=(deg2<deg1 && deg2<deg3 || deg2>deg1 && deg2>deg3);
   exact=(((MathAbs(currasp-allureasp)<MathAbs(prevasp-allureasp) && MathAbs(currasp-allureasp)<MathAbs(nextasp-allureasp)) || (MathAbs(360-currasp-allureasp)<MathAbs(360-prevasp-allureasp) && MathAbs(360-currasp-allureasp)<MathAbs(360-nextasp-allureasp))) && !pivot);
   if(MathAbs(currasp-allureasp)<=allureorb || MathAbs(360-currasp-allureasp)<=allureorb || exact)DrawSymb(date, price, clr, 108, "*0*", pcurr);
  
   allureasp=90;
   exact=(((MathAbs(currasp-allureasp)<MathAbs(prevasp-allureasp) && MathAbs(currasp-allureasp)<MathAbs(nextasp-allureasp)) || (MathAbs(360-currasp-allureasp)<MathAbs(360-prevasp-allureasp) && MathAbs(360-currasp-allureasp)<MathAbs(360-nextasp-allureasp))) && !pivot);
   if(MathAbs(currasp-allureasp)<=allureorb || MathAbs(360-currasp-allureasp)<=allureorb || exact)DrawSymb(date, price, clr, 110, "*90*", pcurr);

   allureasp=120;
   exact=(((MathAbs(currasp-allureasp)<MathAbs(prevasp-allureasp) && MathAbs(currasp-allureasp)<MathAbs(nextasp-allureasp)) || (MathAbs(360-currasp-allureasp)<MathAbs(360-prevasp-allureasp) && MathAbs(360-currasp-allureasp)<MathAbs(360-nextasp-allureasp))) && !pivot);
   if(MathAbs(currasp-allureasp)<=allureorb || MathAbs(360-currasp-allureasp)<=allureorb || exact)DrawSymb(date, price, clr, 169, "*120*", pcurr);
 
   allureasp=180;
   exact=(((MathAbs(currasp-allureasp)<MathAbs(prevasp-allureasp) && MathAbs(currasp-allureasp)<MathAbs(nextasp-allureasp)) || (MathAbs(360-currasp-allureasp)<MathAbs(360-prevasp-allureasp) && MathAbs(360-currasp-allureasp)<MathAbs(360-nextasp-allureasp))) && !pivot);
   if(MathAbs(currasp-allureasp)<=allureorb || MathAbs(360-currasp-allureasp)<=allureorb || exact)DrawSymb(date, price, clr, 118, "*180*", pcurr);
  }
  
  void CheckHouse(double deg1, double deg2, double deg3, double natdeg, double price, datetime date, string hnum)
  {
  double d;
  
  double deg1dec=deg1/10-MathFloor(deg1/10);
  double deg2dec=deg2/10-MathFloor(deg2/10);
  double deg3dec=deg3/10-MathFloor(deg3/10);
  double natdegdec=natdeg/10-MathFloor(natdeg/10);
  
  double d1=MathAbs(deg1dec-natdegdec);
  double d2=MathAbs(deg2dec-natdegdec);
  double d3=MathAbs(deg3dec-natdegdec);
   
  if(d2<d1 && d2<d3)d=NormalizeDouble(deg2,0); else return;
  natdeg=NormalizeDouble(natdeg, 0);
  //if(sizeshift==2.02)Print(deg2, date, clr, U, " ", P," ", J);
  
   if(d==natdeg)
   {
   string name=pcurr+"/"+hnum+"/"+(string)date+"/"+(string)numlabel;
   ObjectCreate(ChartID(), name, OBJ_TEXT, 0, date, price);
   ObjectSetString(ChartID(), name, OBJPROP_TEXT, hnum); 
   ObjectSetInteger(ChartID(), name,OBJPROP_FONTSIZE,13); 
   ObjectSetInteger(ChartID(), name,OBJPROP_COLOR,clrPlum); 
   ObjectSetInteger(ChartID(), name,OBJPROP_BACK,false); 
   ObjectSetInteger(ChartID(),name,OBJPROP_SELECTABLE,false);
   
   ArrayResize(labelarr, numlabel+10, 500);
   labelarr[numlabel]=name;
   numlabel++;
   }
  }

//+------------------------------------------------------------------+

void CheckPlanet(double deg1, double deg2, double deg3, double price, datetime date, string pcurr)
{
   if(AspectToMercury)CheckAspect(deg1, deg2, deg3, ME, price, date, clrSpringGreen, pcurr);
   if(AspectToSun)CheckAspect(deg1, deg2, deg3, SU, price, date, clrYellow, pcurr);
   if(AspectToMoon)CheckAspect(deg1, deg2, deg3, L, price, date, clrAqua, pcurr);
   if(AspectToVenus)CheckAspect(deg1, deg2, deg3, V, price, date, clrOrange, pcurr);
   if(AspectToMars)CheckAspect(deg1, deg2, deg3, MA, price, date, clrRed, pcurr);
   if(AspectToJupiter)CheckAspect(deg1, deg2, deg3, J, price, date, clrGreen, pcurr);
   if(AspectToSaturn)CheckAspect(deg1, deg2, deg3, SA, price, date, clrGray, pcurr);
   if(AspectToUranus)CheckAspect(deg1, deg2, deg3, U, price, date, clrKhaki, pcurr);
   if(AspectToNeptune)CheckAspect(deg1, deg2, deg3, N, price, date, clrBlue, pcurr);
   if(AspectToPluto)CheckAspect(deg1, deg2, deg3, P, price, date, clrBlack, pcurr);
   
   if(ShowHouses)
   {
   CheckHouse(deg1, deg2, deg3, H1, price, date, "I");
   CheckHouse(deg1, deg2, deg3, H2, price, date, "II");
   CheckHouse(deg1, deg2, deg3, H3, price, date, "III");
   CheckHouse(deg1, deg2, deg3, H4, price, date, "IV");
   CheckHouse(deg1, deg2, deg3, H5, price, date, "V");
   CheckHouse(deg1, deg2, deg3, H6, price, date, "VI");
   CheckHouse(deg1, deg2, deg3, H7, price, date, "VII");
   CheckHouse(deg1, deg2, deg3, H8, price, date, "VIII");
   CheckHouse(deg1, deg2, deg3, H9, price, date, "IX");
   CheckHouse(deg1, deg2, deg3, H10, price, date, "X");
   CheckHouse(deg1, deg2, deg3, H11, price, date, "XI");
   CheckHouse(deg1, deg2, deg3, H12, price, date, "XII");
   }
   
   } 
 //===============================================================
   void DrawLabel(string name, string text, datetime date, double price)
   {
   ObjectCreate(ChartID(), name, OBJ_TEXT, 0, date, price);
   ObjectSetString(ChartID(), name, OBJPROP_TEXT, text); 
   ObjectSetInteger(ChartID(), name,OBJPROP_FONTSIZE,30); 
   ObjectSetInteger(ChartID(), name,OBJPROP_COLOR,clrGainsboro); 
   ObjectSetInteger(ChartID(), name,OBJPROP_BACK,true); 
   ObjectSetInteger(ChartID(),name,OBJPROP_SELECTABLE,false);
   
   //ArrayResize(labelarr, numlabel+10, 500);
   //labelarr[numlabel]=name;
   numlabel++;
   }
//===========================================================================
bool ReadTransit(string Filename, string &currU[], string &PU1[], string &PU2[], int &aspU[], datetime &dateU[])
{
  int uranfile=FileOpen(Filename,FILE_READ|FILE_TXT|InpEncodingType);
if(uranfile!=INVALID_HANDLE)
{
      string newstr=FileReadString(uranfile);
      for(int i=0; StringToInteger(StringSubstr(newstr, 0, 3))==0; i++)newstr=FileReadString(uranfile);
            
      for(int i=0; !FileIsEnding(uranfile); i++)
      {     
            ArrayResize(currU, i+1, 20000);
            ArrayResize(PU1, i+1, 20000);
            ArrayResize(PU2, i+1, 20000);
            ArrayResize(aspU, i+1, 20000);
            ArrayResize(dateU, i+1, 20000);
   
   currU[i]=newstr;
   if(StringSubstr(currU[i], 0, 1)!=" ")  //для старого Урануса
   {
   dateU[i]=StringToTime(StringSubstr(currU[i], 0, 10)+StringSubstr(currU[i], 10, 6));
   PU1[i]=(string)StringSubstr(currU[i], 21, 3);
   PU2[i]=StringSubstr(currU[i], 25, 12);
   aspU[i]=(int)StringToInteger(StringSubstr(currU[i], 41, 3));
   }else
   {
   dateU[i]=StringToTime(StringSubstr(currU[i], 1, 10)+StringSubstr(currU[i], 11, 6));
   PU1[i]=StringSubstr(currU[i], 23, 3);
   PU2[i]=StringSubstr(currU[i], 27, 12);
   aspU[i]=StringToInteger(StringSubstr(currU[i], 40, 3));
   }
   
   newstr=FileReadString(uranfile);if(newstr=="")break;
      }
     FileClose(uranfile); //Print(ArraySize(currU), "  ",PU1[5006], PU2[5006]);
}else {ArrayFree(currU); return(false);}
return(true);
}

//===========================================================================
/*bool ReadFiltr(string Filename, string &period[], string &astro[], color &coltype[])
{
  int filtrfile=FileOpen(Filename,FILE_READ|FILE_TXT|InpEncodingType);
if(filtrfile!=INVALID_HANDLE)
{
      string newstr=FileReadString(filtrfile);
      for(int i=0; !FileIsEnding(filtrfile); i++)
      {     
            ArrayResize(period, i+1, 20000);
            ArrayResize(coltype, i+1, 20000);
   
      period[i]=StringSubstr(Text2,0,StringFind(Text2,";",0));// 
      Two=StringSubstr(Text2,StringFind(Text2,";",0)+1,StringFind(Text2,";",StringFind(Text2,";",0)+1)-StringFind(Text2,";",0)-1);
      Three=StringSubstr(Text2,StringLen(Text2)-4,3);

   
   newstr=FileReadString(uranfile);if(newstr=="")break;
      }
     FileClose(uranfile); //Print(ArraySize(currU), "  ",PU1[5006], PU2[5006]);
}else {ArrayFree(currU); return(false);}
return(true);
}*/
 //===========================================================================
 string GetPlanet(int combo)
 {
       switch(combo)
     {
     case 1: return("SUN"); 
     case 2: return("MON"); 
     case 3: return("MER"); 
     case 4: return("VEN");
     case 5: return("MRS");
     case 6: return("JUP"); 
     case 7: return("SAT"); 
     case 8: return("URN"); 
     case 9: return("NEP"); 
     case 10: return("PLT"); 
     case 11: return("HIR");  
     case 12: return("NDE");  
     case 13: return("SDE"); 
     case 14: return("H.1"); 
     case 15: return("H.2"); 
     case 16: return("H.3");
     case 17: return("H.4");
     case 18: return("H.5"); 
     case 19: return("H.6"); 
     case 20: return("H.7"); 
     case 21: return("H.8"); 
     case 22: return("H.9"); 
     case 23: return("H.10"); 
     case 24: return("H.11"); 
     case 25: return("H.12"); 
     default: return("");  
     }
 }
 
    string sigsearch(int combo)
{
     switch(combo)
     {
     case 0: return("Овен");
     case 1: return("Телец"); 
     case 2: return("Близнецы"); 
     case 3: return("Рак"); 
     case 4: return("Лев"); 
     case 5: return("Дева"); 
     case 6: return("Весы"); 
     case 7: return("Скорпион"); 
     case 8: return("Стрелец"); 
     case 9: return("Козерог"); 
     case 10: return("Водолей"); 
     case 11: return("Рыбы");      
          default: return("");  
     }
}
//==================================
  string GetPlanetRU(int combo)
 {
       switch(combo)
     {
     case 1: return("Солнце"); 
     case 2: return("Луна"); 
     case 3: return("Меркурий"); 
     case 4: return("Венера");
     case 5: return("Марс");
     case 6: return("Юпитер"); 
     case 7: return("Сатурн"); 
     case 8: return("Уран"); 
     case 9: return("Нептун"); 
     case 10: return("Плутон"); 
     case 11: return("Хирон");  
     case 12: return("В.узел(NDE)");  
     case 13: return("Н.узел(SDE)"); 
     case 14: return("AS"); 
     case 15: return("II дом"); 
     case 16: return("III дом");
     case 17: return("IC");
     case 18: return("V дом"); 
     case 19: return("VI дом"); 
     case 20: return("DS"); 
     case 21: return("VIII дом"); 
     case 22: return("IX дом"); 
     case 23: return("MC"); 
     case 24: return("XI дом"); 
     case 25: return("XII дом"); 
     default: return("");  
     }
 }

//==================================16:18 21.12.18
  string GetPlanet3(int combo)
 {
       switch(combo)
     {
     case 0: return("Rahu");
     case 1: return("Sun"); 
     case 2: return("Moon"); 
     case 3: return("Mercury"); 
     case 4: return("Venus");
     case 5: return("Mars");
     case 6: return("Jupiter"); 
     case 7: return("Saturn"); 
     case 8: return("Uranus"); 
     case 9: return("Neptun"); 
     case 10: return("Pluto"); 
     case 11: return("Hiron");
     case 12: return("В.узел(NDE)");  
     case 13: return("Н.узел(SDE)"); 
     case 14: return("H.1"); 
     case 15: return("H.2"); 
     case 16: return("H.3");
     case 17: return("H.4");
     case 18: return("H.5"); 
     case 19: return("H.6"); 
     case 20: return("H.7"); 
     case 21: return("H.8"); 
     case 22: return("H.9"); 
     case 23: return("H.10"); 
     case 24: return("H.11"); 
     case 25: return("H.12"); 
     default: return("");  
     }
 }
//void SearchNatal(int cobo1,int combo3,color 



  //=================================================================== draw all Allur
 void DrawFromAllur (string Filename, string Filename2, string Filename3, string dateM, string dateY,string ris,long test,long test2, long fklaster,long fnklaster)
  {      datetime date,dateA,dateI,dateF, drawdate,dateA2,date1,date2;
  string aspectF,aspectI,aspectA,aspectA2,aspect1,aspect2;
   double pricedataH[1];pricedataH[0]=0;
      int copyH;
             string instr; string type; string aspect; string newmass[50], typemass[10]; 
      int massnum=0, typenum=0; 
         ExtDialog.m_list_view.ItemAdd("", 0);
   int i=0; string newstr;
   
   int n=9,count=0,count2=0;
string ftype[10],klaster[10];
//if (test>0) {
//Print(test);Print(test2);
for ( n=9;n>=0;n--) {
 if ((test-(1<<n))>=0) {

      switch(n)
     {
     case 0: ftype[n]="Allyr"; break;
     case 1: ftype[n]="SP500"; break;
     case 2: ftype[n]="NYSE"; break;
     case 3: ftype[n]="USA"; break;
     case 4: ftype[n]="DJIA"; break;
     case 5: ftype[n]="RTS"; break;
     case 6: ftype[n]="YA"; break;
     case 7: ftype[n]="NEFT"; break;
     case 8: ftype[n]="BENZ"; break;
     case 9: ftype[n]="DIST"; break;  
     }
test=test-(1<<n);}}
for ( n=9;n>=0;n--) {
 if ((test2-(1<<n))>=0){
      switch(n)
     {
     case 0: klaster[n]="K"; break;
     case 1: klaster[n]="K"; break;
     case 2: klaster[n]="K"; break;
     case 3: klaster[n]="K"; break;
     case 4: klaster[n]="K"; break;
     case 5: klaster[n]="K"; break;
     case 6: klaster[n]="K"; break;
     case 7: klaster[n]="K"; break;
     case 8: klaster[n]="K"; break;
     case 9: klaster[n]="K"; break;  
     }test2=test2-(1<<n);
}
} 
int cases=0;

//ObjectsDeleteAll(ChartID(), 0, OBJ_ARROW);

int txtfile;
 if (ftype[0]=="Allyr") if (fklaster==0) {
        txtfile=FileOpen(DirectoryName+"\\"+Filename,FILE_READ|FILE_TXT|InpEncodingType);
if(txtfile!=INVALID_HANDLE) 


      for(i=0; !FileIsEnding(txtfile); i++)
      {
      newstr=FileReadString(txtfile); 

 massnum=StringSplit(newstr, 9, newmass); 
 if (massnum<8) {
 instr=newmass[2]; 
 type=newmass[3]; 
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6]+" "+newmass[7];
   date=StringToTime(newmass[0]+" "+newmass[1]);} else {
    instr=newmass[4]; 
 type=newmass[massnum-6]; 
  aspect=newmass[massnum-5]+" "+newmass[massnum-4]+" "+newmass[massnum-3]+" "+newmass[massnum-2]+" "+newmass[massnum-1];//Print(aspect);
    date=StringToTime(newmass[0]+"."+newmass[1]+"."+newmass[2]+" "+newmass[3]+" "+newmass[4]);
   }
string Col; int codedraw=0;
color typecolor;
     MqlDateTime str;
      Col    =newmass[massnum-1];

        if(StringFind(Col,"K",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;codedraw=240;                      // .. и такой цвет верт. линии
        }
        if(StringFind(Col,"k",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;codedraw=240;                      // .. и такой цвет верт. линии
        }else
        if((StringFind(aspect,"60",0)>=0)||(StringFind(aspect,"120",0)>=0))     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrGreen;codedraw=241;                      // .. и такой цвет верт. линии
        }else
        if(StringFind(aspect,"90",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }if(StringFind(aspect,"180",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }if(StringFind(aspect,"45",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }if(StringFind(aspect,"135",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }if((StringFind(instr+" "+type+" "+aspect,"аспектов 0",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"соединений",0)>=0))     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;codedraw=108;                      // .. и такой цвет верт. линии
        }
        else
        if((StringFind(instr+" "+type+" "+aspect,"ингресс",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"фаз",0)>0))     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;codedraw=240;                      // .. и такой цвет верт. линии
        }/*else
      if (instr=="SP500")
              {                           // .. финансовому инструменту..
         typecolor =clrBlue;codedraw=118;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        }
        else if (instr=="DJIA")
              {                           // .. финансовому инструменту..
         typecolor =clrMagenta;codedraw=91;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        }        
        else if (instr=="NYSE")
              {                           // .. финансовому инструменту..
         typecolor =clrWhite;codedraw=82;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="NEFT")
              {                           // .. финансовому инструменту..
         typecolor =clrAqua;codedraw=74;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="BENZ")
              {                           // .. финансовому инструменту..
         typecolor =clrMediumVioletRed;codedraw=77;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="DIST")
              {                           // .. финансовому инструменту..
         typecolor =clrOrange;codedraw=73;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        }          
       if(StringFind(Col,"1",0)>=0)     // А для событий по нашему ..
        {                           // .. финансовому инструменту..
         typecolor =clrGreen;codedraw=241;                      // .. и такой цвет верт. линии
        }
        else if(StringFind(Col,"2",0)>=0)      // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }
        else if(StringFind(Col,"3",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;codedraw=240;                      // .. и такой цвет верт. линии
        } else
        if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;codedraw=108;                      // .. и такой цвет верт. линии
        }*/
   TimeToStruct(date, str);
   drawdate=date;
   if(str.day_of_week==0)drawdate=date+86400;
   if(str.day_of_week==6)drawdate=date-86400;
//Print("оно "+IntegerToString(StringFind(klaster[0],"K",0)),StringFind(Col,"K",0),newmass[massnum-1]);
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);  
   if (klaster[0]=="K"){
   
   if (ris=="Данные") 
      {
      if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", instr+" "+type+" "+aspect); else 
      if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", instr+" "+type+" "+aspect);
      if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM))){DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", instr+" "+type+" "+aspect);}
      }else
   if ((ris=="Раскраску")&&(codedraw!=0)&&((StringFind(instr+" "+type+" "+aspect,"аспект",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"соединен",0)>=0))) 
   {
         if ((dateM=="-")&&(dateY=="-"))  DrawSymb(date, pricedataH[0]*1.01, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY)) DrawSymb(date, pricedataH[0]*1.01, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM))) { DrawSymb(date, pricedataH[0]*1.01, typecolor, codedraw, "", instr+" "+type+" "+aspect) ;}
   }}else 
      if (ris=="Данные") {
      if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", instr+" "+type+" "+aspect); else 
      if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", instr+" "+type+" "+aspect);
      if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM))){DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", instr+" "+type+" "+aspect);}
      }else
      if ((ris=="Раскраску")&&(codedraw!=0)) {
      if ((dateM=="-")&&(dateY=="-"))  if (date<TimeCurrent()) DrawSymb(date, pricedataH[0]*1.01, typecolor, codedraw, "", instr+" "+type+" "+aspect);
      else {DrawSymb(date, pricedataH[0]*1, clrWhite, 158, "", "");if (codedraw==241) DrawSymb(date, pricedataH[0]*0.99, typecolor, codedraw, "", instr+" "+type+" "+aspect); else DrawSymb(date, pricedataH[0]*1.01, typecolor, codedraw, "", instr+" "+type+" "+aspect);} else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY)) DrawSymb(date, pricedataH[0]*1.01, typecolor, codedraw, "", instr+" "+type+" "+aspect); 
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM))) { DrawSymb(date, pricedataH[0]*1.01, typecolor, codedraw, "", instr+" "+type+" "+aspect) ;}}
         else
   if (ris=="Д+Р"){
               if ((dateM=="-")&&(dateY=="-")) {DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", instr+" "+type+" "+aspect);if (codedraw!=0) DrawSymb(date, pricedataH[0]*1.025, typecolor, codedraw, "", instr+" "+type+" "+aspect);} else 
               if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY)){DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", instr+" "+type+" "+aspect);if (codedraw!=0) DrawSymb(date, pricedataH[0]*1.025, typecolor, codedraw, "", instr+" "+type+" "+aspect);}
               if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM))){DrawSymb(date, pricedataH[0]*1.01, clrWhite, 108, "", type+" "+instr+" "+aspect);
   if (codedraw!=0) DrawSymb(date, pricedataH[0]*1.025, typecolor, codedraw, "", instr+" "+type+" "+aspect);}}
   
   }
FileClose(txtfile); 

}else if (fklaster==1) {
   txtfile=FileOpen(DirectoryName+"\\"+Filename,FILE_READ|FILE_TXT|InpEncodingType);
if(txtfile!=INVALID_HANDLE) 

      for(i=0; !FileIsEnding(txtfile); i++)
      {
      newstr=FileReadString(txtfile); 
 massnum=StringSplit(newstr, 9, newmass); 
 if (massnum<8) {
 instr=newmass[2]; 
 type=newmass[3]; 
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6]+" "+newmass[7];
   date=StringToTime(newmass[0]+" "+newmass[1]);} else {
    instr=newmass[4]; 
 type=newmass[massnum-6]; 
  aspect=newmass[massnum-5]+" "+newmass[massnum-4]+" "+newmass[massnum-3]+" "+newmass[massnum-2];
    date=StringToTime(newmass[0]+"."+newmass[1]+"."+newmass[2]+" "+newmass[3]+" "+newmass[4]);
   }
string Col; int codedraw=0;
color typecolor;
     MqlDateTime str;
     
      Col    =newmass[massnum-1];
      if((StringFind(instr+" "+type+" "+aspect,"аспектов 0",0)>=0)/*||(StringFind(instr+" "+type+" "+aspect,"соединений",0)>=0)*/)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         aspectA=instr+" "+type+" "+aspect; dateA=date; 
        }
        else
        if (StringFind(instr+" "+type+" "+aspect,"фаз",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         aspectF=instr+" "+type+" "+aspect;dateF=date;  
        }else
        if (StringFind(instr+" "+type+" "+aspect,"ингресс",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         aspectI=instr+" "+type+" "+aspect;dateI=date;
        }
        //Print((StringFind(aspectA,"аспект",0))>=0,((StringFind(aspectF,"фаз",0))>=0),((StringFind(aspectI,"ингресс",0))>=0),((MathAbs(int(dateA)-int(dateF)))<=100*86400),((MathAbs(int(dateA)-int(dateI)))<=100*86400));
        //Print(aspectA,aspectF,aspectI,((MathAbs(int(dateA)-int(dateF)))<=100*86400),((MathAbs(int(dateA)-int(dateI)))<=100*86400));
        if ((((StringFind(aspectA,"аспект",0))>=0)&&((StringFind(aspectF,"фаз",0))>=0)&&((StringFind(aspectI,"ингресс",0))>=0))&&(((MathAbs(int(dateA)-int(dateF)))<=3*86400)&&((MathAbs(int(dateA)-int(dateI)))<=3*86400))) {
   TimeToStruct(dateA, str);//typecolor =clrYellow;codedraw=108;

   drawdate=dateA;
   if(str.day_of_week==0)drawdate=dateA+86400;
   if(str.day_of_week==6)drawdate=dateA-86400;

   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); //Print(aspectf);
      if ((dateM=="-")&&(dateY=="-"))  {if (dateA<TimeCurrent()) {
        
        for (int ign=0;ign<12;ign++)
        if (StringFind(aspectI,signsIngression[ign],0)>=0)
        codedraw=94+ign;
      DrawSymb(dateA, pricedataH[0]*1.01, clrYellow, 108, "", aspectA);
      DrawSymb(dateI, pricedataH[0]*1.015, clrGreen, 108, "", aspectI);
      DrawSymb(dateF, pricedataH[0]*1.02, clrRed, 108, "", aspectF);
            aspectA="";aspectI="";aspectF="";
      }

      else {
      for (int ign=0;ign<12;ign++)
        if (StringFind(aspectI,signsIngression[ign],0)>=0)
        codedraw=94+ign;
      DrawSymb(date, pricedataH[0]*1, clrWhite, 158, "", "");      
      DrawSymb(dateA, pricedataH[0]*1.01, clrYellow, 108, "", aspectA);
      DrawSymb(dateI, pricedataH[0]*1.015, clrGreen, 108, "", aspectI);
      DrawSymb(dateF, pricedataH[0]*1.02, clrRed, 108, "", aspectF);
      aspectA="";aspectI="";aspectF="";
      }}
      
      else        
         if ((dateM=="-")&&(dateY!="-")){if (str.year==StringToInteger(dateY)) { 
         
                 for (int ign=0;ign<12;ign++)
        if (StringFind(aspectI,signsIngression[ign],0)>=0)
        codedraw=94+ign;
      DrawSymb(dateA, pricedataH[0]*1.01, clrYellow, 108, "", aspectA);
      DrawSymb(dateI, pricedataH[0]*1.015, clrGreen, 108, "", aspectI);
      DrawSymb(dateF, pricedataH[0]*1.02, clrRed, 108, "", aspectF);
            aspectA="";aspectI="";aspectF="";
         }}else          
         if ((dateM!="-")&&(dateY!="-")) if ((str.year==StringToInteger(dateY))&&(str.mon==StringToInteger(dateM))) { 
         
                 for (int ign=0;ign<12;ign++)
        if (StringFind(aspectI,signsIngression[ign],0)>=0)
        codedraw=94+ign;
      DrawSymb(dateA, pricedataH[0]*1.01, clrYellow, 108, "", aspectA);
      DrawSymb(dateI, pricedataH[0]*1.015, clrGreen, 108, "", aspectI);
      DrawSymb(dateF, pricedataH[0]*1.02, clrRed, 108, "", aspectF);
            aspectA="";aspectI="";aspectF="";
         }

}
}
FileClose(txtfile); 
}else if (fklaster==2) { 
   txtfile=FileOpen(DirectoryName+"\\"+Filename,FILE_READ|FILE_TXT|InpEncodingType);
if(txtfile!=INVALID_HANDLE) 

      for(i=0; !FileIsEnding(txtfile); i++)
      {
      newstr=FileReadString(txtfile); 
 massnum=StringSplit(newstr, 9, newmass); 
 if (massnum<8) {
 instr=newmass[2]; 
 type=newmass[3]; 
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6]+" "+newmass[7];
   date=StringToTime(newmass[0]+" "+newmass[1]);} else {
    instr=newmass[4]; 
 type=newmass[massnum-6]; 
  aspect=newmass[massnum-5]+" "+newmass[massnum-4]+" "+newmass[massnum-3]+" "+newmass[massnum-2];
    date=StringToTime(newmass[0]+"."+newmass[1]+"."+newmass[2]+" "+newmass[3]+" "+newmass[4]);
   }
string Col; int codedraw=0;
color typecolor;
     MqlDateTime str;
     
      if((StringFind(instr+" "+type+" "+aspect,"Jupiter",0)>=0)&&(StringFind(instr+" "+type+" "+aspect,"Mars",0)>=0)&&(StringFind(instr+" "+type+" "+aspect,"90",0)>=0))
        {
         aspectA=instr+" "+type+" "+aspect; dateA=date;//Print(aspectA);
        }
      if((StringFind(instr+" "+type+" "+aspect,"Jupiter",0)>=0)&&(StringFind(instr+" "+type+" "+aspect,"Mars",0)>=0)&&(StringFind(instr+" "+type+" "+aspect,"120",0)>=0))
        {
         aspectA2=instr+" "+type+" "+aspect; dateA2=date; //Print(aspectA2);
        } 
        if ((int(dateA2)<int(dateA))&&(StringFind(instr+" "+type+" "+aspect,"Moon",0)>=0)&&(StringFind(instr+" "+type+" "+aspect,"Телец",0)>=0)&&((StringFind(instr+" "+type+" "+aspect,"аспектов 0",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"соединен",0)>=0))) 
        {
         aspectF=instr+" "+type+" "+aspect;dateF=date;//Print(aspectF);
        }
        if ((int(dateA2)<int(dateA))&&(StringFind(instr+" "+type+" "+aspect,"Moon",0)>=0)&&(StringFind(instr+" "+type+" "+aspect,"Овен",0)>=0)&&((StringFind(instr+" "+type+" "+aspect,"аспектов 0",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"соединен",0)>=0))) 
        {
         aspectI=instr+" "+type+" "+aspect;dateI=date;//Print(aspectI);
        }
        if (int(dateA2)<int(dateA)) {
   TimeToStruct(dateA, str);//typecolor =clrYellow;codedraw=108;
   
if ((dateM=="-")&&(dateY=="-"))   {

   drawdate=dateA;
   if(str.day_of_week==0)drawdate=dateA+86400;
   if(str.day_of_week==6)drawdate=dateA-86400;

   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);     
      DrawSymb(dateA, pricedataH[0]*1.01, clrYellow, 232, "", aspectA);
      
   drawdate=dateA2;
   if(str.day_of_week==0)drawdate=dateA2+86400;
   if(str.day_of_week==6)drawdate=dateA2-86400;
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); 
    DrawSymb(dateA2, pricedataH[0]*1.01, clrWhite, 231, "", aspectA2);

   drawdate=dateI;
   if(str.day_of_week==0)drawdate=dateI+86400;
   if(str.day_of_week==6)drawdate=dateI-86400;
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);
   DrawSymb(dateI, pricedataH[0]*1.01, clrGreen, 233, "", aspectI);


    drawdate=dateF;
   if(str.day_of_week==0)drawdate=dateF+86400;
   if(str.day_of_week==6)drawdate=dateF-86400;
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);
   DrawSymb(dateF, pricedataH[0]*1.01, clrRed, 234, "", aspectF);
      
      }

      else {
      DrawSymb(dateA, pricedataH[0]*1.01, clrWhite, 158, "", aspectA);      
      DrawSymb(dateA2, pricedataH[0]*1.01, clrYellow, 108, "", aspectA2);
      DrawSymb(dateI, pricedataH[0]*1.015, clrGreen, 108, "", aspectI);
      DrawSymb(dateF, pricedataH[0]*1.02, clrRed, 108, "", aspectF);
      }

}
}
FileClose(txtfile); 
} else if (fklaster==4) { 
   txtfile=FileOpen(DirectoryName+"\\"+Filename,FILE_READ|FILE_TXT|InpEncodingType);
if(txtfile!=INVALID_HANDLE) 

      for(i=0; !FileIsEnding(txtfile); i++)
      {
      newstr=FileReadString(txtfile); 
 massnum=StringSplit(newstr, 9, newmass); 
 if (massnum<8) {
 instr=newmass[2]; 
 type=newmass[3]; 
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6]+" "+newmass[7];
   date=StringToTime(newmass[0]+" "+newmass[1]);} else {
    instr=newmass[4]; 
 type=newmass[massnum-6]; 
  aspect=newmass[massnum-5]+" "+newmass[massnum-4]+" "+newmass[massnum-3]+" "+newmass[massnum-2];
    date=StringToTime(newmass[0]+"."+newmass[1]+"."+newmass[2]+" "+newmass[3]+" "+newmass[4]);
   }
string Col; int codedraw=0;
color typecolor;
     MqlDateTime str;
     
      if((StringFind(instr+" "+type+" "+aspect,"Sun",0)>=0)&&(StringFind(instr+" "+type+" "+aspect,"Moon",0)>=0)&&((StringFind(instr+" "+type+" "+aspect,"аспектов 0",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"соединен",0)>=0)))
        {
         aspectA=instr+" "+type+" "+aspect; dateA=date;
        }
      if((StringFind(instr+" "+type+" "+aspect,"Sun",0)>=0)&&(StringFind(instr+" "+type+" "+aspect,"Merc",0)>=0)&&((StringFind(instr+" "+type+" "+aspect,"аспектов 0",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"соединен",0)>=0)))
        {
         aspectA2=instr+" "+type+" "+aspect; dateA2=date;
        } 

        if ((MathAbs(int(dateA)-int(dateA2))<3*86400)&&(dateA!=dateA2)&&(StringFind(aspectA,"Sun",0)>=0)&&(StringFind(aspectA2,"Merc",0)>=0)) {
   TimeToStruct(dateA, str);//typecolor =clrYellow;codedraw=108;
if ((dateM=="-")&&(dateY=="-"))   {

   drawdate=dateA;
   if(str.day_of_week==0)drawdate=dateA+86400;
   if(str.day_of_week==6)drawdate=dateA-86400;

   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);     
      DrawSymb(dateA, pricedataH[0]*1.01, clrGreen, 108, "", aspectA);
      TimeToStruct(dateA2, str);
   drawdate=dateA2;
   if(str.day_of_week==0)drawdate=dateA2+86400;
   if(str.day_of_week==6)drawdate=dateA2-86400;
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); 
    DrawSymb(dateA2, pricedataH[0]*1.01, clrRed, 108, "", aspectA2);
      }

}
}
FileClose(txtfile); 
}else if (fklaster==8) { 
   txtfile=FileOpen(DirectoryName+"\\"+Filename,FILE_READ|FILE_TXT|InpEncodingType);
if(txtfile!=INVALID_HANDLE) 

      for(i=0; !FileIsEnding(txtfile); i++)
      {
      newstr=FileReadString(txtfile); 
 massnum=StringSplit(newstr, 9, newmass); 
 if (massnum<8) {
 instr=newmass[2]; 
 type=newmass[3]; 
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6]+" "+newmass[7];
   date=StringToTime(newmass[0]+" "+newmass[1]);} else {
    instr=newmass[4]; 
 type=newmass[massnum-6]; 
  aspect=newmass[massnum-5]+" "+newmass[massnum-4]+" "+newmass[massnum-3]+" "+newmass[massnum-2];
    date=StringToTime(newmass[0]+"."+newmass[1]+"."+newmass[2]+" "+newmass[3]+" "+newmass[4]);
   }
string Col; int codedraw=108;
color typecolor;
     MqlDateTime str;
      int y=3; for (int y1=0;y1<11;y1++)
         if(((StringFind(instr+" "+type+" "+aspect,GetPlanet3(y),0)>=0)&&
         (StringFind(instr+" "+type+" "+aspect,GetPlanet3(y1),0)>=0))&&(y!=y1)&&((StringFind(instr+" "+type+" "+aspect,"аспектов 0",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"соединен",0)>=0))) {
         
   TimeToStruct(date, str);//typecolor =clrYellow;codedraw=108;
if ((dateM=="-")&&(dateY=="-"))   {
   drawdate=date;
   if(str.day_of_week==0)drawdate=date+86400;
   if(str.day_of_week==6)drawdate=date-86400;

   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);     
      DrawSymb(date, pricedataH[0]*1.01, clrWheat, codedraw+y1, "", instr+" "+type+" "+aspect);

      }



}
}
FileClose(txtfile); 
}







txtfile=FileOpen(DirectoryNameN+"\\"+Filename2,FILE_READ|FILE_TXT|InpEncodingType);
if(txtfile!=INVALID_HANDLE) 


      for(i=0; !FileIsEnding(txtfile); i++)
      {
      newstr=FileReadString(txtfile); 
 
 massnum=StringSplit(newstr, 9, newmass); //Print(massnum);
 if (massnum<8) {
 instr=newmass[2]; //Print(instr);
 type=newmass[3]; 
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6];
   date=StringToTime(newmass[0]+" "+newmass[1]);} else if (StringLen(newmass[0])>2){
    instr=newmass[2]; //Print(instr);
 type=newmass[3]; //Print(type);
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6]+" "+newmass[7];//Print(aspect);
    date=StringToTime(newmass[0]+" "+newmass[1]);//Print(date);
   } else {
 instr=newmass[4]; 
 type=newmass[5]; 
  aspect=newmass[6]+" "+newmass[7];
    date=StringToTime(newmass[0]+"."+newmass[1]+"."+newmass[2]+" "+newmass[3]);}
string Col;
color typecolor;int codedraw=0;
     MqlDateTime str;
      Col    =newmass[massnum-1];
      
        if (instr=="USA")
              {                           // .. финансовому инструменту..
         typecolor =clrDarkOrchid;codedraw=178;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"Транзит",0)>=0)
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"Минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"Трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"Профекция",0)>=0)) typecolor=clrBlue;
        }else
      if (instr=="SP500")
              {                           // .. финансовому инструменту..
         typecolor =clrBlue;codedraw=118;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"Транзит",0)>=0)
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"Минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"Трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"Профекция",0)>=0)) typecolor=clrBlue;
        }
        else if (instr=="DJIA")
              {                           // .. финансовому инструменту..
         typecolor =clrMagenta;codedraw=91;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"Транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"Минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"Трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"Профекция",0)>=0) typecolor=clrBlue;
        }        
        else if (instr=="NYSE")
              {                           // .. финансовому инструменту..
         typecolor =clrWhite;codedraw=82;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"Транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"Минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"Трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"Профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="NEFT")
              {                           // .. финансовому инструменту..
         typecolor =clrAqua;codedraw=74;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="BENZ")
              {                           // .. финансовому инструменту..
         typecolor =clrMediumVioletRed;codedraw=77;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="DIST")
              {                           // .. финансовому инструменту..
         typecolor =clrOrange;codedraw=73;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        }  
   TimeToStruct(date, str);
   drawdate=date;
   if(str.day_of_week==0)drawdate=date+86400;
   if(str.day_of_week==6)drawdate=date-86400;
         
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);
   for (n=0;n<10;n++)if ((instr==ftype[n]) && (klaster[n]=="K")){
   if ((ris=="Раскраску")&&(codedraw!=0)&&((StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"Транзит",0)>=0))) {
         if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM)))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);};
   }else if ((instr==ftype[n])&&(fnklaster==0))
    {
         if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM)))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);}
         else 
         if ((instr==ftype[n])&&(fnklaster==1))
         for (int y=5;y<10;y++) for (int y1=5;y1<10;y1++)
         if(((StringFind(instr+" "+type+" "+aspect,GetPlanetRU(y),0)>=0)&&(StringFind(instr+" "+type+" "+aspect,GetPlanetRU(y1),0)>=0)
         ||(StringFind(instr+" "+type+" "+aspect,GetPlanet3(y),0)>=0)&&(StringFind(instr+" "+type+" "+aspect,GetPlanet3(y1),0)>=0))&&(y!=y1))         
          {
         if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM)))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);}
         else if ((instr==ftype[n])&&(fnklaster==2))
        {
        for (int y=5;y<11;y++) for (int y1=13;y1<25;y1++)
         if((((StringFind(instr+" "+type+" "+aspect,GetPlanetRU(y),0)>=0)&&(StringFind(instr+" "+type+" "+aspect,GetPlanetRU(y1),0)>=0)
         ||(StringFind(instr+" "+type+" "+aspect,GetPlanet3(y),0)>=0)&&(StringFind(instr+" "+type+" "+aspect,GetPlanet3(y1),0)>=0))&&(y!=y1)))          
          {
         if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM)))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);};
       
        
        
        };
     if (fnklaster==4)
     {int z;
     for (z=13;z<23;z=z+3)
     if (((StringFind(instr+" "+type+" "+aspect,GetPlanet(5))>0)||StringFind(instr+" "+type+" "+aspect,GetPlanetRU(5))>0||StringFind(instr+" "+type+" "+aspect,GetPlanet3(5))>0)&&
     (StringFind(instr+" "+type+" "+aspect,GetPlanet(z))>0||StringFind(instr+" "+type+" "+aspect,GetPlanetRU(z))>0||StringFind(instr+" "+type+" "+aspect,GetPlanet3(z))>0)&&(StringFind(instr+" "+type+" "+aspect,"ранз")>0)) {date1=date;aspect1=instr+" "+type+" "+aspect;} 
     else
     if (((StringFind(instr+" "+type+" "+aspect,GetPlanet(4))>0)||StringFind(instr+" "+type+" "+aspect,GetPlanetRU(4))>0||StringFind(instr+" "+type+" "+aspect,GetPlanet3(4))>0)&&
     (StringFind(instr+" "+type+" "+aspect,GetPlanet(10))>0||StringFind(instr+" "+type+" "+aspect,GetPlanetRU(10))>0||StringFind(instr+" "+type+" "+aspect,GetPlanet3(10))>0)) {date2=date;aspect2=instr+" "+type+" "+aspect;}
     
     if (MathAbs(int(date1)-int(date2))<3*86400) 
     {
     if ((dateM=="-")&&(dateY=="-")) 
      {
        drawdate=date1;
          if(str.day_of_week==0)drawdate=dateA+86400;
          if(str.day_of_week==6)drawdate=dateA-86400;
   
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);     
      DrawSymb(date1, pricedataH[0]*1.01, clrYellow, 108, "", aspect1);
      TimeToStruct(date2, str);
   drawdate=date2;
   if(str.day_of_week==0)drawdate=date2+86400;
   if(str.day_of_week==6)drawdate=date2-86400;
      copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); 
    DrawSymb(date2, pricedataH[0]*1.01, clrRed, 108, "", aspect2);
      }
      }
     }
     }

FileClose(txtfile); 


txtfile=FileOpen(DirectoryNameN+"\\"+Filename3,FILE_READ|FILE_TXT|InpEncodingType);
if(txtfile!=INVALID_HANDLE) 


      for(i=0; !FileIsEnding(txtfile); i++)
      {
      newstr=FileReadString(txtfile); 
 
 massnum=StringSplit(newstr, 9, newmass); //Print(massnum);
 if (massnum<8) {
 instr=newmass[2]; //Print(instr);
 type=newmass[3]; 
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6];
   date=StringToTime(newmass[0]+" "+newmass[1]);} else if (StringLen(newmass[0])>2){
    instr=newmass[2]; //Print(instr);
 type=newmass[3]; //Print(type);
  aspect=newmass[4]+" "+newmass[5]+" "+newmass[6]+" "+newmass[7];//Print(aspect);
    date=StringToTime(newmass[0]+" "+newmass[1]);//Print(date);
   } else {
 instr=newmass[4]; 
 type=newmass[5]; 
  aspect=newmass[6]+" "+newmass[7];
    date=StringToTime(newmass[0]+"."+newmass[1]+"."+newmass[2]+" "+newmass[3]);}//Print(date,instr,type);
string Col;
color typecolor;int codedraw=0;
     MqlDateTime str;
      Col    =newmass[massnum-1];
      
        if (instr=="USA")
              {                           // .. финансовому инструменту..
         typecolor =clrDarkOrchid;codedraw=178;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"Транзит",0)>=0)
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"Минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"Трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"Профекция",0)>=0)) typecolor=clrBlue;
        }
      if (instr=="SP500")
              {                           // .. финансовому инструменту..
         typecolor =clrBlue;codedraw=118;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        }
        else if (instr=="DJIA")
              {                           // .. финансовому инструменту..
         typecolor =clrMagenta;codedraw=91;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        }        
        else if (instr=="NYSE")
              {                           // .. финансовому инструменту..
         typecolor =clrWhite;codedraw=82;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrDarkOrange;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="NEFT")
              {                           // .. финансовому инструменту..
         typecolor =clrAqua;codedraw=74;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrWhite;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="BENZ")
              {                           // .. финансовому инструменту..
         typecolor =clrMediumVioletRed;codedraw=74;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrFireBrick;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } else if (instr=="DIST")
              {                           // .. финансовому инструменту..
         typecolor =clrOrange;codedraw=74;                      // .. и такой цвет верт. линии
         if(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         typecolor =clrYellow;                      // .. и такой цвет верт. линии
        }else if((StringFind(instr+" "+type+" "+aspect,"минор",0)>=0)||(StringFind(instr+" "+type+" "+aspect,"трет",0)>=0))
        {                              // .. финансовому инструменту..
         typecolor =clrOrange;                      // .. и такой цвет верт. линии
        }else if(StringFind(instr+" "+type+" "+aspect,"профекция",0)>=0) typecolor=clrBlue;
        } 
   TimeToStruct(date, str);
   drawdate=date;
   if(str.day_of_week==0)drawdate=date+86400;
   if(str.day_of_week==6)drawdate=date-86400;
         
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);
   
   for (n=0;n<10;n++)if ((instr==ftype[n]) && (klaster[n]=="K")){
   if ((ris=="Раскраску")&&(codedraw!=0)&&(StringFind(instr+" "+type+" "+aspect,"транзит",0)>=0)) {
         if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM)))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);};
   } else if ((instr==ftype[n])&&fnklaster==0)  {if ((ris=="Раскраску")&&(codedraw!=0)) {
         if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM)))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);};}
   else if ((instr==ftype[n])&&(fnklaster==1))
         {
         for (int y=5;y<10;y++) for (int y1=5;y1<10;y1++)
         if(((StringFind(instr+" "+type+" "+aspect,GetPlanetRU(y),0)>=0)&&(StringFind(instr+" "+type+" "+aspect,GetPlanetRU(y1),0)>=0)
         ||(StringFind(instr+" "+type+" "+aspect,GetPlanet3(y),0)>=0)&&(StringFind(instr+" "+type+" "+aspect,GetPlanet3(y1),0)>=0))&&(y!=y1)) 
         {
         if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM)))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);};
       
        } else if ((instr==ftype[n])&&(fnklaster==2))
        {
        for (int y=5;y<11;y++) for (int y1=13;y1<25;y1++)
         if((((StringFind(instr+" "+type+" "+aspect,GetPlanetRU(y),0)>=0)&&(StringFind(instr+" "+type+" "+aspect,GetPlanetRU(y1),0)>=0)
         ||(StringFind(instr+" "+type+" "+aspect,GetPlanet3(y),0)>=0)&&(StringFind(instr+" "+type+" "+aspect,GetPlanet3(y1),0)>=0))&&(y!=y1)))          
          {
         if ((dateM=="-")&&(dateY=="-")) DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect); else 
         if ((dateM=="-")&&(dateY!="-")) if (str.year==StringToInteger(dateY))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);
         if ((dateM!="-")&&(dateY!="-") )if (str.year==StringToInteger(dateY)&&(str.mon==StringToInteger(dateM)))DrawSymb(date, pricedataH[0]*1.035, typecolor, codedraw, "", instr+" "+type+" "+aspect);};}
       
        
        
        
 if (fnklaster==8)
     {int z;
     for (z=13;z<23;z=z+3)
     if (((StringFind(instr+" "+type+" "+aspect,GetPlanet(5))>0)||StringFind(instr+" "+type+" "+aspect,GetPlanetRU(5))>0||StringFind(instr+" "+type+" "+aspect,GetPlanet3(5))>0)&&
     (StringFind(instr+" "+type+" "+aspect,GetPlanet(z))>0||StringFind(instr+" "+type+" "+aspect,GetPlanetRU(z))>0||StringFind(instr+" "+type+" "+aspect,GetPlanet3(z))>0)&&(StringFind(instr+" "+type+" "+aspect,"ранз")>0)) {date1=date;aspect1=instr+" "+type+" "+aspect;} 
     else
     if (((StringFind(instr+" "+type+" "+aspect,GetPlanet(4))>0)||StringFind(instr+" "+type+" "+aspect,GetPlanetRU(4))>0||StringFind(instr+" "+type+" "+aspect,GetPlanet3(4))>0)&&
     (StringFind(instr+" "+type+" "+aspect,GetPlanet(10))>0||StringFind(instr+" "+type+" "+aspect,GetPlanetRU(10))>0||StringFind(instr+" "+type+" "+aspect,GetPlanet3(10))>0)) {date2=date;aspect2=instr+" "+type+" "+aspect;}
     
     if (MathAbs(int(date1)-int(date2))<3*86400) 
     {
     if ((dateM=="-")&&(dateY=="-")) 
      {
        drawdate=date1;
          if(str.day_of_week==0)drawdate=dateA+86400;
          if(str.day_of_week==6)drawdate=dateA-86400;
   
   copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH);     
      DrawSymb(date1, pricedataH[0]*1.01, typecolor, codedraw, "", aspect1);
      TimeToStruct(date2, str);
   drawdate=date2;
   if(str.day_of_week==0)drawdate=date2+86400;
   if(str.day_of_week==6)drawdate=date2-86400;
      copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); 
    DrawSymb(date2, pricedataH[0]*1.01, typecolor, codedraw, "", aspect2);
      }
      }
     }
     
        
       }
               
FileClose(txtfile); 


if ((dateM!="-")&&(dateY!="-"))ChartNavigate(ChartID(),CHART_BEGIN,Bars(NULL,ChartPeriod(ChartID()))-iBarShift(NULL,ChartPeriod(ChartID()),StringToTime(dateY+"."+dateM+".1")));
if ((dateM=="-")&&(dateY!="-"))ChartNavigate(ChartID(),CHART_BEGIN,Bars(NULL,ChartPeriod(ChartID()))-iBarShift(NULL,ChartPeriod(ChartID()),StringToTime(dateY+"."+"01.01")));

} 
 //===================================================================
  void DrawFromExcel(string combo1, string combo2, string combo3, string method,string file,color typecolor, string dateM, string dateY,int countasp)
  { 
  
     string aspectF,aspectI,aspectA,aspectA2,aspect1,aspect2;
   
             string instr; string type; string aspect; string newmass[50], typemass[10]; 
      int massnum=0, typenum=0; 
     if(file=="НЕТ.txt")return; 
//    ExtDialog.m_list_view.ItemAdd("", 0);

   string Psearch1,Psearch1RU,Psearch11;
  string Psearch2,Psearch2RU,Psearch21;
     for (int x1=0;x1<26;x1++) {
     if (combo1==GetPlanetRU(x1)) Psearch1=GetPlanet(x1);
     if (combo3==GetPlanetRU(x1)) Psearch2=GetPlanet(x1);
     if (combo3==GetPlanet(x1)) Psearch2=GetPlanet(x1);
     if (combo3==sigsearch(x1)) {Psearch2=sigsearch(x1);combo2=" ";}

     
     }

     datetime date, drawdate;
   double pricedataH[1];pricedataH[0]=0;
   int copyH;
   MqlDateTime str;

 string met="",met2="";
   int i=0; string newstr;
  int exceltxt=FileOpen(file,FILE_READ|FILE_TXT|InpEncodingType);
if(exceltxt!=INVALID_HANDLE)
{
//    ObjectsDeleteAll(ChartID(), 0, OBJ_ARROW);
//    ObjectsDeleteAll(ChartID(), 0, OBJ_LABEL);                       
       for(i=0; !FileIsEnding(exceltxt); i++)
      {
      newstr=FileReadString(exceltxt); 
  massnum=StringSplit(newstr, 9, newmass); //Print(massnum);
 if (StringFind(newstr,"Ингрессии",0)>=0) met=newstr;
 if (StringFind(newstr,"ПЕТЛИ",0)>=0) met=newstr;
 if (StringFind(newstr,"Текущие аспекты",0)>=0) met=newstr;
  if (StringFind(newstr,"К натальной карте",0)>=0) met=newstr;
  if (StringFind(newstr,"ОСТАНОВКИ",0)>=0) {met=newstr;}
if (StringFind(newstr,"Метод",0)>=0) met2=newstr;

     MqlDateTime str;
   color codecolor=clrRed;
   int codedraw=116;
   if (StringFind(met,"Ингрессии",0)>=0)
      {
   date=StringToTime(StringSubstr(newstr, 1, 10)+StringSubstr(newstr, 11, 6));
   aspect=StringSubstr(newstr, 19,StringLen(newstr)-19);
      codecolor=clrWhite;codedraw=81; //Print(aspect,date);
      }else 
   if (StringFind(met,"ОСТАНОВКИ",0)>=0)  
      {
   date=StringToTime(StringSubstr(newstr, 1, 10)+StringSubstr(newstr, 11, 6));
   aspect=met+StringSubstr(newstr, StringLen(newstr)-1, 1); 
           if (StringFind(aspect,"R",0)>=0) codecolor =clrWhite;codedraw=162; 
           if (StringFind(aspect,"D",0)>=0) codecolor =clrYellow;codedraw=162; 
            
         drawdate=date;//Print(aspect);
   if(str.day_of_week==0)drawdate=date+86400;
   if(str.day_of_week==6)drawdate=date-86400;
      copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); 
   DrawSymb(date, pricedataH[0]*1.01, codecolor, codedraw, "",StringSubstr(file,StringFind(file,"\\",14)+1,StringLen(file)-StringFind(file,"\\",14)-5)+" "+aspect);
      } else
   if (StringFind(met,"Текущие аспекты",0)>=0)

   if(StringSubstr(newstr, 0, 1)!=" ")  //для старого Урануса
   {
   date=StringToTime(StringSubstr(newstr, 0, 10)+StringSubstr(newstr, 10, 6));
   aspect=StringSubstr(newstr, 21, 3)+" "+StringSubstr(newstr, 25, 12)+" "+StringToInteger(StringSubstr(newstr, 41, 3));
   codecolor=clrWhite;codedraw=116;
   }else
   {
   date=StringToTime(StringSubstr(newstr, 1, 10)+StringSubstr(newstr, 11, 6));
   aspect=StringSubstr(newstr, 23, 3)+" "+StringSubstr(newstr, 27, 12)+" "+StringToInteger(StringSubstr(newstr, 40, 3));
   codecolor=clrWhite;codedraw=116;
   }
            if((StringFind(aspect,"60",0)>=0)||(StringFind(aspect,"120",0)>=0))     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         codecolor =clrGreen;codedraw=241;                      // .. и такой цвет верт. линии
        }else
        if(StringFind(aspect,"90",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         codecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }if(StringFind(aspect,"180",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         codecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }if(StringFind(aspect,"45",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         codecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }if(StringFind(aspect,"135",0)>=0)     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         codecolor =clrRed;codedraw=242;                      // .. и такой цвет верт. линии
        }if((StringFind(aspect," 0",0)>=0))     // А для событий по нашему ..
        {                              // .. финансовому инструменту..
         codecolor =clrYellow;codedraw=108;                      // .. и такой цвет верт. линии
        }
        
   if (StringFind(met,"К натальной карте",0)>=0)
      {
   date=StringToTime(StringSubstr(newstr, 1, 10)+StringSubstr(newstr, 11, 6)); 
   aspect=StringSubstr(newstr, 23, 3)+" "+StringSubstr(newstr, 27, 12)+" "+StringToInteger(StringSubstr(newstr, 40, 3));//Print(aspect);
   codecolor=clrDeepSkyBlue;codedraw=116;
      

           
        if (StringFind(met,"США",0)>=0)
              {                           // .. финансовому инструменту..
         codecolor =clrDarkOrchid;codedraw=178;                      // .. и такой цвет верт. линии
         }
      if (StringFind(met,"SP500",0)>=0)
              {        
         codecolor =clrBlue;codedraw=118;}
 
        if (StringFind(met,"DJIA",0)>=0)
              { 
         codecolor =clrMagenta;codedraw=91; 
}
        if (StringFind(met,"NYSE",0)>=0)
         {codecolor =clrWhite;codedraw=82;  }
            if (StringFind(met,"Нефть",0)>=0)
              {
         codecolor =clrAqua;codedraw=74;
         } 
         if (StringFind(met,"BБЕНЗИН",0)>=0)
              {                           
         codecolor =clrMediumVioletRed;codedraw=74;          
         
        } 
        if (StringFind(met,"Дистилляты",0)>=0)
            {                
         codecolor =clrOrange;codedraw=74;     
            }

        
        
        if(StringFind(met2,"Профекция",0)>=0) codecolor=clrBlue;
         if(StringFind(met2,"Транзит",0)>=0)  codecolor =clrYellow; 
         if((StringFind(met2,"Минор",0)>=0)||(StringFind(met2,"трет",0)>=0))
         codecolor =clrOrange;

//if (StringFind(aspect,"H.",0)>=0)   codecolor =clrYellow; 

}
//Print(met2,codedraw,aspect,codecolor);
/*   if ((combo1==1)&&(combo3==1||combo3==3||(combo3>4&&combo3<10))) codecolor=clrOrange;
   if ((combo1==3)&&(combo3==1||combo3==3||combo3==6||combo3==8)) codecolor=clrOrange;
   if ((combo1==4)&&(combo3==8||combo3==9)) codecolor=clrOrange;
   if ((combo1==5)&&(combo3==5||combo3==6||combo3==9)) codecolor=clrOrange;
   if ((combo1==6)&&(combo3==3||(combo3>4&&combo3<9)||combo3==10)) codecolor=clrOrange;   
   if ((combo1==7)&&(combo3==5||(combo3>4&&combo3<9))) codecolor=clrOrange;
   if ((combo1==8)&&(combo3==1||combo3==3||combo3==4||combo3==6||combo3==7||combo3==8||combo3==9)) codecolor=clrOrange;
   if ((combo1==9)&&(combo3==1||combo3==4||combo3==7||combo3==8||combo3==9||combo3==10)) codecolor=clrOrange;
   if ((combo1==10)&&(combo3==6||combo3==9||combo3==10)) codecolor=clrOrange;
   
   if ((combo1==1)&&(combo3==4)) codecolor=clrGreen;
   if ((combo1==3)&&(combo3==4||combo3==7)) codecolor=clrGreenYellow;
   if ((combo1==4)&&(combo3==1||combo3==3||combo3==4||combo3==5||combo3==6||combo3==7)) codecolor=clrGreen;
   if ((combo1==5)&&(combo3==4)) codecolor=clrGreen;
   if ((combo1==6)&&(combo3==1||combo3==4||combo3==9)) codecolor=clrGreen;   
   if ((combo1==7)&&(combo3==4)) codecolor=clrGreen;
   
   if ((combo1==9)&&(combo3==6)) codecolor=clrGreenYellow;
   
   if ((combo1==1)&&(combo3==5||combo3==10)) codecolor=clrRed;
   if ((combo1==3)&&(combo3==5||combo3==9||combo3==10)) codecolor=clrRed;
   if ((combo1==4)&&(combo3==10)) codecolor=clrRed;
   if ((combo1==5)&&(combo3==1||combo3==3||combo3==8||combo3==10)) codecolor=clrRed;
   
   if ((combo1==7)&&(combo3==1||combo3==9||combo3==10)) codecolor=clrRed;
   if ((combo1==8)&&(combo3==5)) codecolor=clrRed;
   if ((combo1==9)&&(combo3==3||combo3==5)) codecolor=clrRed;
   if ((combo1==10)&&(combo3==1||combo3==3||combo3==4||combo3==5||combo3==7||combo3==8)) codecolor=clrRed;


  */ 
      if ((StringFind(aspect,Psearch1)>=0||StringFind(aspect,Psearch1RU)>=0||StringFind(aspect,Psearch11)>=0)&&
      (StringFind(aspect,Psearch2+" ")>=0||StringFind(aspect,Psearch2RU)>=0||StringFind(aspect,Psearch21)>=0)&&(StringFind(aspect,combo2)>=0||StringFind(aspect,combo2)>=0))
      {
      drawdate=date;
   if(str.day_of_week==0)drawdate=date+86400;
   if(str.day_of_week==6)drawdate=date-86400;
      copyH=CopyHigh(ChartSymbol(0), PERIOD_H4, drawdate, 1, pricedataH);
   if(copyH<0)copyH=CopyHigh(ChartSymbol(0), PERIOD_D1, drawdate, 1, pricedataH); 
    DrawSymb(date, pricedataH[0]*MathPow(1.01,countasp), codecolor, codedraw, "",StringSubstr(file,StringFind(file,"\\",14)+1,StringLen(file)-StringFind(file,"\\",14)-5)+" "+aspect);
      }
}}else ExtDialog.m_list_view.ItemInsert(0, "Нет файла с текстом из Excel "+ExcelFileName, 0);             

if ((dateM!="-")&&(dateY!="-"))ChartNavigate(ChartID(),CHART_BEGIN,Bars(NULL,ChartPeriod(ChartID()))-iBarShift(NULL,ChartPeriod(ChartID()),StringToTime(dateY+"."+dateM+".1")));
if ((dateM=="-")&&(dateY!="-"))ChartNavigate(ChartID(),CHART_BEGIN,Bars(NULL,ChartPeriod(ChartID()))-iBarShift(NULL,ChartPeriod(ChartID()),StringToTime(dateY+"."+"01.01")));

FileClose(exceltxt);
}   
 //==================================================================
 
void AnalyzeAllure(int combo1, int combo3, double allureasp, double allureorb, color allureclr, string pcurr)
{   
   ExtDialog.m_list_view.ItemAdd("", 0);

     switch(combo1)
     {
     case 1: ArrayCopy(Pone, degSU); break;
     case 2: ArrayCopy(Pone, degL); break;
     case 3: ArrayCopy(Pone, degME); break;
     case 4: ArrayCopy(Pone, degV); break;
     case 5: ArrayCopy(Pone, degMA); break;
     case 6: ArrayCopy(Pone, degJ); break;
     case 7: ArrayCopy(Pone, degSA); break;
     case 8: ArrayCopy(Pone, degU); break;
     case 9: ArrayCopy(Pone, degN); break;
     case 10: ArrayCopy(Pone, degP); break;
     }
     switch(combo3)
     {
     case 1: ArrayCopy(Ptwo, degSU); break;
     case 2: ArrayCopy(Ptwo, degL); break;
     case 3: ArrayCopy(Ptwo, degME); break;
     case 4: ArrayCopy(Ptwo, degV); break;
     case 5: ArrayCopy(Ptwo, degMA); break;
     case 6: ArrayCopy(Ptwo, degJ); break;
     case 7: ArrayCopy(Ptwo, degSA); break;
     case 8: ArrayCopy(Ptwo, degU); break;
     case 9: ArrayCopy(Ptwo, degN); break;
     case 10: ArrayCopy(Ptwo, degP); break;
     }
 
   datetime date, datestart, dateend, dateexact, copydate;//dateexact1, dateexact2;
   double pricedata[1]; pricedata[0]=0;
   double pricedataL[1];pricedataL[0]=0;
   double pricedataH[1];pricedataH[0]=0;
   int copy, copyL, copyH, copyD, copyaspH, copyaspL, copyaspH2, copyaspL2;
   MqlDateTime str;
   double currasp=0, prevasp=0, nextasp=0;
   bool exact=false, onaspect=false, pivot=false, speedcross=false;
   double maxprice=ChartGetDouble(ChartID(), CHART_PRICE_MAX, 0);
   int cases=0;
   /*int preseries=0, postseries=0, daystart=0, dayend=0, dayexact=0;
   int lastsize=1000;
   double aspdeltas[][2][1000];
   if((combo1==8||combo1==9||combo1==10)&&(combo3==8||combo3==9||combo3==10)){double aspdeltas[][2][12000]; lastsize=12000; }
   double aspopenpre[], aspclosepre[], aspopenpost[], aspclosepost[];
   int openpresize=0, closepresize=0, openpostsize=0, closepostsize=0;
   double deltasumm=0, averaspdelta=0, averdelta=0, aspdelta=0, aspdeltapre=0, aspdeltapost=0, aspopen[], aspclose[];
   bool wasexact=false;
   int exactnum=0;
   int totaldays=0; 
      
  ArrayResize(aspdeltas, 1, 100); ArrayResize(aspopenpre, 300, 1000);ArrayResize(aspopenpost, 300, 1000);ArrayResize(aspclosepre, 300, 1000);ArrayResize(aspclosepost, 300, 1000);
  ArrayResize(aspopen, 1, 100); ArrayResize(aspclose, 1, 100);*/
 // for(int i=0; i<100; i++)Print(degJ[i]);
   //degJ[k]>0
   for(int k=1; degJ[k]>0 ; k++) 
   {    //Print(k, " ", date);
   date=StringToTime(StringSubstr(curr[k], 0, 10)+StringSubstr(curr[k], 11, 8)); //Print(date);
   copydate=date;
   TimeToStruct(date, str);
   if(str.day_of_week==0)copydate=date+86400;
   if(str.day_of_week==6)copydate=date-86400; 
      
   copy=CopyHigh(ChartSymbol(0), PERIOD_H4, copydate, 1, pricedataH);
   if(copy<0 && date<TimeCurrent()){copy=CopyHigh(ChartSymbol(0), PERIOD_D1, copydate, 1, pricedataH); ExtDialog.m_list_view.ItemUpdate(0, "Нет истории daily до "+date);}
   if(copy<0)continue;
  
   currasp=MathAbs(Pone[k]-Ptwo[k]); //if(currasp<10)Print(Pone[k], " ", Ptwo[k]);
   prevasp=MathAbs(Pone[k-1]-Ptwo[k-1]);
   nextasp=MathAbs(Pone[k+1]-Ptwo[k+1]); 
   speedcross=((MathAbs(Pone[k-1]-Pone[k])<MathAbs(Ptwo[k-1]-Ptwo[k]) && MathAbs(Pone[k+1]-Pone[k])>MathAbs(Ptwo[k+1]-Ptwo[k])) || (MathAbs(Pone[k-1]-Pone[k])>MathAbs(Ptwo[k-1]-Ptwo[k]) && MathAbs(Pone[k+1]-Pone[k])<MathAbs(Ptwo[k+1]-Ptwo[k])));
   pivot=((Pone[k]>Pone[k-1] && Pone[k]>Pone[k+1]) || (Pone[k]<Pone[k-1] && Pone[k]<Pone[k+1]) || (Ptwo[k]>Ptwo[k-1] && Ptwo[k]>Ptwo[k+1]) || (Ptwo[k]<Ptwo[k-1] && Ptwo[k]<Ptwo[k+1]));
   exact=(((MathAbs(currasp-allureasp)<MathAbs(prevasp-allureasp) && MathAbs(currasp-allureasp)<MathAbs(nextasp-allureasp)) || (MathAbs(360-currasp-allureasp)<MathAbs(360-prevasp-allureasp) && MathAbs(360-currasp-allureasp)<MathAbs(360-nextasp-allureasp))) && !pivot && !speedcross);
   
   if(MathAbs(currasp-allureasp)<=allureorb || MathAbs(360-currasp-allureasp)<=allureorb || exact)
   { //НА АСПЕКТЕ 
   if(!onaspect){datestart=date; cases++; }//ArrayResize(aspdeltas, cases, 100); ArrayResize(aspopen, cases, 100); ArrayResize(aspclose, cases, 100);}
   onaspect=true; //Print(date, " ", currasp);
   
      if(exact) //НА ЭКЗАКТЕ
      {/*
      if(wasexact)
      { 
      
      dateexact2=date;
      if(dateexact2-dateexact1>(TimeDayOfYear(dateexact1)-TimeDayOfYear(datestart))/2)dateend=dateexact1+(dateexact2-dateexact1)/2;
      }
      else{dateexact1=date; exactnum++;}*/
      dateexact=date;
      DrawSymb(date, pricedataH[0]+maxprice/60, allureclr, 116, "", pcurr);
      ExtDialog.m_list_view.ItemInsert(cases, cases+ " "+pcurr+" "+date, 0);
      
     // wasexact=true;
      }
      else {DrawSymb(date, pricedataH[0]+maxprice/60, allureclr, 108, "", pcurr); ExtDialog.m_list_view.ItemInsert(cases, cases+ " "+pcurr+" "+TimeDay(date)+"."+TimeMonth(date)+"."+TimeYear(date)+" "+TimeHour(date)+":"+TimeMinute(date)+":"+TimeSeconds(date), 0);}  
   }
   else 
   {  
      if(onaspect)
      {  //НА ВЫХОДЕ И ИЗ АСПЕКТА
      onaspect=false; /*wasexact=false; dateend=date;// Print(datestart, " ", dateexact, " ", dateend);
      //ArrayFree(aspclosepre); ArrayFree(aspclosepost); ArrayFree(aspopenpre); ArrayFree(aspopenpost);
      if(!(dateexact>=datestart && dateexact<=dateend)){dateexact=datestart+(dateend-datestart)/2; }
     daystart=TimeDayOfYear(datestart); dayend=TimeDayOfYear(dateend); dayexact=TimeDayOfYear(dateexact);
     preseries=dayexact-daystart; if(preseries<0)preseries=366+preseries; if(preseries==0)preseries=1;
     postseries=dayend-dayexact; if(postseries<0)postseries=366+postseries; if(postseries==0)postseries=1;
    //Print(preseries, " ", postseries);//, "//", daystart, " ", dayexact, " ", dayend, " ", datestart, " ", dateexact, " ", dateend);//daystart, " ", dayexact, " ",dayend);
     
     ArrayResize(aspopenpre, preseries+10, 1000);ArrayResize(aspopenpost, postseries+10, 1000);ArrayResize(aspclosepre, preseries+10, 1000);ArrayResize(aspclosepost, postseries+10, 1000); 
     ArrayInitialize(aspclosepre, 0); ArrayInitialize(aspclosepost, 0); ArrayInitialize(aspopenpre, 0); ArrayInitialize(aspopenpost, 0);
     // Print(datestart, " ", dateexact, " ", dateend);
      copyaspL=CopyOpen(ChartSymbol(0), PERIOD_H4, dateexact, dateend-86400,  aspopenpost);
      copyaspH=CopyClose(ChartSymbol(0), PERIOD_H4, dateexact, dateend-86400, aspclosepost);
      copyaspL2=CopyOpen(ChartSymbol(0), PERIOD_H4, datestart, dateexact,  aspopenpre);
      copyaspH2=CopyClose(ChartSymbol(0), PERIOD_H4, datestart, dateexact, aspclosepre);
      
    // Print(ArraySize(aspopenpre), " ", ArraySize(aspopenpost), " ", ArraySize(aspclosepre), " ", ArraySize(aspclosepost));
      openpresize=ArraySize(aspopenpre); openpostsize=ArraySize(aspopenpost); closepresize=ArraySize(aspclosepre); closepostsize=ArraySize(aspclosepost);

      if(copyaspL>0 && copyaspH>0 && copyaspL2>0 && copyaspH2>0)
      {
         int i=0;
         for(i=0; i<closepresize && i<openpresize && aspopenpre[i]>0 ;i++) 
         {
         aspdeltas[cases-1][0][i]=(aspclosepre[i]-aspopenpre[i])/aspopenpre[i]; //Print(datestart, " ", dateexact, " ",dateend, " ",aspdeltas[cases-1][0][i], " ", aspopenpre[i], " ", aspclosepre[i]);//Print(cases, " ",dateexact);//, " ", aspdeltas[cases-1][0][i], " ", aspopenpre[i], " ", aspclosepre[i]);
         }
         aspopen[cases-1]=aspopenpre[0];
         totaldays+=i;
         for(i=0; i<closepostsize && i<openpostsize && aspopenpost[i]>0 ;i++) 
         {
         aspdeltas[cases-1][1][i]=(aspclosepost[i]-aspopenpost[i])/aspopenpost[i]; //Print(dateexact, " ",aspdeltas[cases-1][1][i], " ", aspopenpost[i], " ", aspclosepost[i]);
         }
         aspclose[cases-1]=aspclosepost[i-1];
         totaldays+=i;
      }  
      else{ m_list_view.ItemUpdate(0, "Нет истории daily до "+date); cases--;} */
      } 
    } 
  }   
   
  ExtDialog.m_list_view.ItemInsert(cases+1, "Количество случаев: "+ cases, 0);
  if(cases==0)return;


    //СТАТИСТИКА 
   
        // int deltasize=ArraySize(aspdeltas)/(lastsize*2); // Print(ArraySize(aspdeltas), cases);
         /*
         //СУММА ДЕЛЬТ
         for(int i=0; i<cases ;i++) 
         {
            for(int j=0; aspdeltas[i][0][j]!=0 ;j++) 
            {
            deltasumm+=aspdeltas[i][0][j];   // Print(aspdeltas[i][0][j]);
            }
            for(int j=1; aspdeltas[i][1][j]!=0 ;j++) 
            {
            deltasumm+=aspdeltas[i][1][j];
            } 
         } 
     m_list_view.ItemInsert(0, "Сумма всех дельт: "+ DoubleToString(deltasumm*100, 4)+"%");
     
     //СРЕДНЯЯ ДЕЛЬТА АСПЕКТА
     averaspdelta=deltasumm/cases;
     m_list_view.ItemInsert(0, "Средний аспект: "+ DoubleToString(averaspdelta*100, 4)+"%");
     
         //СРЕДНЯЯ ДНЕВНАЯ ДЕЛЬТА
     if(totaldays!=0)averdelta=deltasumm/totaldays;
     m_list_view.ItemInsert(0, "Средняя дневная дельта:  "+ DoubleToString(averdelta*100, 4)+"%");
     
     //ТРЕНД - ФЛЕТ 
     double trend=0, flat=0, extrem=0, bearish=0, bullish=0;
     double aspmod=0, aspabsmod=0, weak=0, medium=0, strong=0, highext=0, lowext=0, aspbullpower=0, aspbearpower=0;
         for(int i=0; i<cases ;i++) 
         {
         int j=0, k=0;
            aspdelta=0; aspdeltapre=0; aspdeltapost=0;
            for(j=0; aspdeltas[i][0][j]!=0 ;j++) 
            {
            aspdeltapre+=aspdeltas[i][0][j]; 
            }
            for(k=0; aspdeltas[i][1][k]!=0 ;k++) 
            {
            aspdeltapost+=aspdeltas[i][1][k];
            }  
            
            aspdelta=aspdeltapre+aspdeltapost; //Print(j+k-1, " ", (aspclose[i]-aspopen[i])/aspopen[i], " ", aspdelta, " ", aspdeltapre, " ", aspdeltapost);
            if(aspopen[i]==0)continue;
            aspmod=(aspclose[i]-aspopen[i])/aspopen[i]; aspabsmod=MathAbs(aspmod);
            
            if(aspabsmod<TrendDelta)flat++; 
            else 
            {
            if(aspmod>0){bullish++; aspbullpower+=aspabsmod;} else {bearish++; aspbearpower+=aspabsmod;}
            //if(aspabsmod<0.008)weak++;
           // if(aspabsmod>0.008 && aspabsmod<0.018)medium++;
            //if(aspabsmod>0.018)strong++;            
            
            if(aspdeltapre>0 && aspdeltapost<0 && MathMin(MathAbs(aspdeltapre), MathAbs(aspdeltapost))>aspabsmod)highext++;
            else { if(aspdeltapre<0 && aspdeltapost>0 && MathMin(MathAbs(aspdeltapre), MathAbs(aspdeltapost))>aspabsmod)lowext++;else trend++;}
            }
         }
         
         if(trend+flat+highext+lowext>0)
         {
         double trendperc=NormalizeDouble(trend/(trend+flat+highext+lowext)*100, 0); double flatperc=NormalizeDouble(flat/(trend+flat+highext+lowext)*100, 0); double extperc=NormalizeDouble((highext+lowext)/(trend+flat+highext+lowext)*100, 0); 
              m_list_view.ItemInsert(0, "Трендовый:  "+ trendperc +"%" + " Флетовый: " + flatperc + "%" + " Экстремум: " + extperc + "%");
         }
         if(bullish+bearish>0)
         {
         double bullishperc=NormalizeDouble(bullish/(bullish+bearish)*100, 0); double bearishperc=NormalizeDouble(bearish/(bullish+bearish)*100, 0); 
              m_list_view.ItemInsert(0, "Бычий:  "+ bullishperc +"%" + " Медвежий: " + bearishperc + "%");
         }
        // double weakperc=NormalizeDouble(weak/(weak+medium+strong)*100, 0); double mediumperc=NormalizeDouble(medium/(weak+medium+strong)*100, 0); double strongperc=NormalizeDouble(strong/(weak+medium+strong)*100, 0); 
                // m_list_view.ItemInsert(0, "Слабый:  "+ weakperc +"%" + " Средний: " + mediumperc + "%"+ " Сильный: " + strongperc + "%");
        if(bullish>0 && bearish>0) 
        { 
        double bullpower=aspbullpower/bullish*100; double bearpower=aspbearpower/bearish*100;
              m_list_view.ItemInsert(0, "Бычья сила:  "+ DoubleToString(bullpower, 3) + "%"+" Медвежья сила: " + DoubleToString(bearpower, 3)+"%");
        }
                       
                 if((highext+lowext)>0)
                 {
         //double highperc=NormalizeDouble((highext)/(highext+lowext)*100, 0); double lowperc=NormalizeDouble((lowext)/(highext+lowext)*100, 0); 
                 m_list_view.ItemInsert(0, "High:  "+ highext + " Low: " + lowext);
                 }
         */
  }
