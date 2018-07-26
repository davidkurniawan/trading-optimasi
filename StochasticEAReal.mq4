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
input double              StopLossSto        = 300;      //Fixed Stochas Stop Loss (in Points) 
input double              TakeProfitSto      = 200;      //Fixed Stochas Stop Loss (in Points)
extern string             ket1               = "Jika trend sedang bagus downtrend dan uptrend";
input bool                NiceTrend          = true;
extern string             ket2               = "Jika trend sedang Galau Atau Bergerigi Dan Flat";
input bool                FlatTrandSurvive   = false;
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
input ENUM_TIMEFRAMES     MAtimeframe        = PERIOD_CURRENT; //Stochastic TIMEFRAME 
//+------------------------------------------------------------------+
//|     Input PARABOLIC SAR  Current CHAOS TREND OPTIMASI            |
//+------------------------------------------------------------------+
extern double             iSarStep           = 0.02;//Parabolic STEP
extern double             iSarMax            = 0.1;//PARABLOLIC MAX
extern ENUM_TIMEFRAMES    IsarTimeframe      = PERIOD_H1;//PARABOCLIC TIMEFRAME
extern int                iSarShift          = 0;//PARABOLIC SHIFT
//+------------------------------------------------------------------+
//|      Input PARABOLIC SAR  D1 CHAOS TREND OPTIMASI                |
//+------------------------------------------------------------------+
extern string ket4     = "++----PARABOLIC SAR FILTER UNTUK FLAT TREND ATAU MA LAGI FLAT---++";//PARABOLIC SAR UNTUK TREND DI ;
extern double              iSarStepD1        = 0.02;//Parabolic STEP
extern double              iSarMaxD1         = 0.1;//PARABLOLIC MAX
extern ENUM_TIMEFRAMES     IsarTimeframeD1   = PERIOD_D1;//PARABOCLIC TIMEFRAME
extern int                 iSarShiftD1       = 0;//PARABOLIC SHIFT

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
   double Sar = iSAR(Symbol(),IsarTimeframe,iSarStep,iSarMax,iSarShift);
   double SarD1 = iSAR(Symbol(),IsarTimeframeD1,iSarStepD1,iSarMaxD1,iSarShiftD1);
   sto_main_curr  = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_MAIN   ,0);
   sto_sign_curr  = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_SIGNAL ,0);
   sto_main_prev1 = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_MAIN   ,1);
   sto_sign_prev1 = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_SIGNAL ,1);
   sto_main_prev2 = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_MAIN   ,2);
   sto_sign_prev2 = iStochastic (Symbol() ,stochtimeframe ,k_period ,d_period ,slowing ,stoch_method ,price_field ,MODE_SIGNAL ,2);
   //-------------------------------------------------------------------------------------------------------------------------------
   double Pembatas = iMA(NULL,MAtimeframe,PembataseMA,PembatasEmaShift,PembataseMAMethod,PembataseMAApliedTo,0);
   if(NiceTrend)
     {
      if(IsNewCandle())
        {
         if(Bid < Sar)  
         if(Bid > Pembatas) 
             if(sto_main_prev1 < stoch_dn_level && sto_sign_prev2 < stoch_dn_level)
               if((sto_sign_prev2>sto_main_prev2) && (sto_sign_prev1<sto_main_prev1))
               res = OrderSend(Symbol(),OP_BUY,Lot,Ask,3,NormalizeDouble(Bid-StopLossSto*Point,Digits),NormalizeDouble(Ask+TakeProfitSto*Point,Digits),"Stochastic buy",MagicNumber,0,Blue);
         if(Ask > Sar)       
         if(Ask < Pembatas)
            if(sto_main_prev1 > stoch_up_level && sto_sign_prev2 > stoch_up_level) 
               if((sto_sign_prev2<sto_main_prev2) && (sto_sign_prev1>sto_main_prev1))
               res = OrderSend(Symbol(),OP_SELL,Lot,Bid,3,NormalizeDouble(Ask+StopLossSto*Point,Digits),NormalizeDouble(Bid-TakeProfitSto*Point,Digits),"",MagicNumber,0,Red);
         }    
     }
      if(FlatTrandSurvive)
     {
        if(IsNewCandle())
        {
         if(Bid < SarD1)
           {
            if(sto_main_prev1 < stoch_dn_level && sto_sign_prev2 < stoch_dn_level)
            if((sto_sign_prev2>sto_main_prev2) && (sto_sign_prev1<sto_main_prev1)) // MODE SIGNAL LEBIH DARI MODE MAIN && MODE SIGNAL KURANG DARI MODE MAIN 
            res = OrderSend(Symbol(),OP_BUY,2,Ask,3,NormalizeDouble(Bid-StopLossSto*Point,Digits),NormalizeDouble(Ask+TakeProfitSto*Point,Digits),"Stochastic buy",MagicNumber,0,Blue);
           } 
         if(Ask > SarD1)
           {
            if(sto_main_prev1 > 80 && sto_sign_prev2 > 80) 
            if((sto_sign_prev2<sto_main_prev2) && (sto_sign_prev1>sto_main_prev1))
            res = OrderSend(Symbol(),OP_SELL,2,Bid,3,NormalizeDouble(Ask+StopLossSto*Point,Digits),NormalizeDouble(Bid-TakeProfitSto*Point,Digits),"",MagicNumber,0,Red);
         }
        }
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