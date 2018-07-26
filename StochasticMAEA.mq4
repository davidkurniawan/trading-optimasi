//+------------------------------------------------------------------+
//|                                                 StochasticEA.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int                 MagicNumber        = 1982;     //Magic Number
input double              Lot                = 1;        //Fixed Lots
input double              StopLossSto        = 500;      //Fixed Stochas Stop Loss (in Points) 
input double              TakeProfitSto      = 200;      //Fixed Stochas Stop Loss (in Points)

//+------------------------------------------------------------------+
//| Input stochastic SETTING                                         |
//+------------------------------------------------------------------+
input string              name_ind1            = "Stochastic setting diharapkan untuk disetting dengan strategi anda";
input int                 k_period             = 14;        //Stochastic K Period
input int                 d_period             = 3;        //Stochastic D Period
input int                 slowing              = 3;        //Stochastic Slowing
input ENUM_MA_METHOD      stoch_method         = MODE_SMA; //Stochastic Moving Average Type
input ENUM_TIMEFRAMES     stochtimeframe       = PERIOD_CURRENT; //Stochastic TIMEFRAME 
extern int                price_field          = 0; //Price field parameter. Can be one of this values: 0 - Low/High or 1 - Close/Close.
extern int                stoch_up_level       = 70;                         // level up - Stochas 
extern int                stoch_up_midle       = 55;
extern int                stoch_down_midle     = 45;
extern int                stoch_dn_level       = 30;                         // level down - Stochas
extern int                stoch_flat_level     = 50;
//+------------------------------------------------------------------+
//|    Pembatas MA                                                   |
//+------------------------------------------------------------------+
input int PembataseMA                        = 144;//prtiod ema pembatas
input int PembatasEmaShift                   = 0;//MA shift. Indicators line offset relate to the chart by timeframe
input ENUM_MA_METHOD PembataseMAMethod       = MODE_EMA;
input ENUM_APPLIED_PRICE PembataseMAApliedTo = PRICE_MEDIAN;
input ENUM_TIMEFRAMES     MAtimeframe        = PERIOD_H1; //Stochastic TIMEFRAME 
//+------------------------------------------------------------------+
//|    Pembatas MA D1                                                |
//+------------------------------------------------------------------+
input int PembataseMAD1                        = 144;//prtiod ema pembatas
input int PembatasEmaShiftD1                   = 0;//MA shift. Indicators line offset relate to the chart by timeframe
input ENUM_MA_METHOD PembataseMAMethodD1       = MODE_EMA;
input ENUM_APPLIED_PRICE PembataseMAApliedToD1 = PRICE_MEDIAN;
input ENUM_TIMEFRAMES     MAtimeframeD1        = PERIOD_D1; //Stochastic TIMEFRAME 

double sto_main_curr,sto_sign_curr,sto_main_prev1,sto_sign_prev1,sto_main_prev2,sto_sign_prev2 ,currentStopLoss,openPrice,newStoploss;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  int res;
   
   double PembatasD1 = iMA(NULL,MAtimeframe,PembataseMA,PembatasEmaShift,PembataseMAMethod,PembataseMAApliedTo,0);
   sto_main_curr  = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_MAIN   ,0);
   sto_sign_curr  = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_SIGNAL ,0);
   sto_main_prev1 = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_MAIN   ,1);
   sto_sign_prev1 = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_SIGNAL ,1);
   sto_main_prev2 = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_MAIN   ,2);
   sto_sign_prev2 = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_SIGNAL ,2);
   //-------------------------------------------------------------------------------------------------------------------------------
   double Pembatas = iMA(NULL,MAtimeframe,PembataseMA,PembatasEmaShift,PembataseMAMethod,PembataseMAApliedTo,0);

     
      setLabel("Kondisi Trend D1: "+kondisid1(),"Max Lot ",20,20,10,Aqua);
      setLabel("Kondisi Trend H1: "+kondisih1(),"stl ",20,40,10,Aqua);
      
      if(IsNewCandle())
        {
         if(Bid > PembatasD1) //BEARISH 
         if(Bid > Pembatas)//BULLISH 
            if(sto_main_prev1 > stoch_up_level && sto_sign_prev2 > stoch_up_level) //STOCHASTIC DIATAS 80
               if((sto_sign_prev2<sto_main_prev2) && (sto_sign_prev1>sto_main_prev1)) // MODE SIGNAL KURANG DARI MODE MAIN && MODE SIGNAL LEBIH DARI MODE MAIN KONDISI SELL
               res = OrderSend(Symbol(),OP_SELL,Lot,Bid,3,NormalizeDouble(Ask+StopLossSto*Point,Digits),NormalizeDouble(Bid-TakeProfitSto*Point,Digits),"",MagicNumber,0,Red);    
         if(Ask < PembatasD1)
            if(Ask < Pembatas)
            if(sto_main_prev1 < stoch_dn_level && sto_sign_prev2 < stoch_dn_level) //STOCHASTIC DIBAWAH 20
               if((sto_sign_prev2>sto_main_prev2) && (sto_sign_prev1<sto_main_prev1))// MODE SIGNAL LEBIH DARI MODE MAIN && MODE SIGNAL KURANG DARI MODE MAIN KONDISI SELL
               res = OrderSend(Symbol(),OP_BUY,Lot,Ask,3,NormalizeDouble(Bid-StopLossSto*Point,Digits),NormalizeDouble(Ask+TakeProfitSto*Point,Digits),"Stochastic buy",MagicNumber,0,Blue);
        }           
  }
//+------------------------------------------------------------------+
bool IsNewCandle()
  {
   static int  barsonchart=0;
   if(Bars==barsonchart)
      return(false);
   barsonchart=Bars;
   return(true);
  }
  
  string kondisid1(){
  
  double PembatasD1 = iMA(NULL,MAtimeframe,PembataseMA,PembatasEmaShift,PembataseMAMethod,PembataseMAApliedTo,0);
  string kondisitrendD1;
   if(Bid > PembatasD1) //BERRISH D1
      {
      kondisitrendD1 ="BEARISH D1";
       
      }
   if(Ask < PembatasD1) //BULLISH D1
     {
    kondisitrendD1 = "BULLISH D1";
     
     }
     return(kondisitrendD1);
  }
  
  string kondisih1(){
  
  double Pembatas = iMA(NULL,MAtimeframe,PembataseMA,PembatasEmaShift,PembataseMAMethod,PembataseMAApliedTo,0);
  string kondisitrendh1;
   
   if(Bid > Pembatas) //BULLISH H1
      {
      kondisitrendh1 = "BULLISH H1";
       
      }
   if(Ask < Pembatas) //BEARISH H1
     {
      kondisitrendh1 = "BEARISH H1";
       
     }
     return(kondisitrendh1); 
  }
    
    
  string setLabel(string labelText,string name,int xdist,int ydist,int fontSize,color Color)
  {

   if(ObjectFind(name)!=-1) ObjectDelete(name);
   ObjectCreate(name,OBJ_LABEL,0,0,0,0,0);
   ObjectSetText(name,labelText,fontSize,"Arial",clrAqua);
   ObjectSet(name,OBJPROP_COLOR,Color);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,xdist);
   ObjectSet(name,OBJPROP_YDISTANCE,ydist);
   return (true);
  }