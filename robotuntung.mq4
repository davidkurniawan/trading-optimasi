//Close nya harus di ubah dan di kasih stoploss
//ambil code nya yang lots

//+------------------------------------------------------------------+
#property copyright "Copyright © 2018 David Kurniawan"
#define MAGICMA  20131111
extern string    Keteranganseven        = "Moving Evarage Setting"; 
input int FasteMA=5;
input int FastEmaShift=0;
input int FasteMAMethod=0;
input int FasteMAApliedTo=0;
input int SloweMA=21;
input int SlowEmaShift=0;
input int SloweMAMethod=0;
input int SloweMAApliedTo=0;
input int K_Period=50; 
input int D_Period=3;
input int SlowingStato=3;


extern string    Keteranganone          = "Use Profit False ,Kondisi True Untuk Gold Atau Point yang berbeda";
extern bool      useProfitToClose       = false;
extern double    profitSellToClose      = 30;
extern double    profitBuyToClose       = 40;
extern string    Keterangantwo          = "Use useLossToClose True ,Kondisi False Jika tidak ingin dipakai";
extern bool      useLossToClose         = false;
extern double    lossToClose            = 400;
extern string    Keteranganthree        = "Use AllSymbols False ,Kondisi True untuk menyatukan profit dari semua mata uang";
extern bool      AllSymbols             = false;
extern string    Keteranganfour         = "Use PendingOrders False ,Kondisi True Jika ada pending order";
extern bool      PendingOrders          = false;
extern double    MaxSlippage            = 3;  
extern string    Keteranganfive         = "Use showMenu true ,Kondisi False Jika Tidak ingin menampilkan"; 
extern bool      showMenu               = true;
extern color     menuColor              = Blue; 
extern color     variablesColor         = Red;
extern int       font                   = 10;
input double     LotsLots               = 0.5;
input int        stoploss               = 60;
input int        takeprofit             = 300;

extern string    Keterangansix          = "Movebreak event setting use strateggy must!!"; 
input string Break_Even_Settings;// Padding must be lower than Trigger
input bool bUseBreakEven=true;// Use Break Even (BE)
input int inTrigger=500; // If BE=[true] set Points in profit to trigger
input int inPadding=250; // Padding points to add to BE must be lower than trigger

input int inTriggerone=600; // If BE=[true] set Points in profit to trigger200
input int inPaddingone=300; // Padding points to add to BE must be lower than trigger350

input int inTriggertwo=800; //
input int inPaddingtwo=500; //

input int inTriggerthree=1000; //
input int inPaddingthree=750; //

input int inTriggerfour=1200; //
input int inPaddingfour=1000; //

input int inTriggerfive=1400; //
input int inPaddingfive=1150; //

input int inTriggerSix=1600; //
input int inPaddingSix=1400; //

input int inTriggerSeven=1800; //
input int inPaddingSeven=1600; //

input int inTriggerEight=2000; //
input int inPaddingEight=1800; //

input int inTriggerNine=2200; //
input int inPaddingNine=2000; //

input int inTriggerTen=2400; //
input int inPaddingTen=2200; //

input int inTriggerSebelas=2600; //
input int inPaddingSebelas=2400; //

input int inTriggerDuaBelas=2800; //
input int inPaddingDuaBelas=2600; //

input int inTriggerTigaBelas=3000; //
input int inPaddingTigaBelas=2800; //

input int inTriggerEmpatBelas=3200; //
input int inPaddingEmpatBelas=3000; //

input int inTriggerLimaBelas=3400; //
input int inPaddingLimaBelas=3200; //

input int inTriggerEnamBelas=3600; //
input int inPaddingEnamBelas=3400; //

double pips2dbl, pips2point,pips, pipValue, maxSlippage,profit,profitSell,profitBuy,currentStopLoss,openPrice,newStoploss;
             
bool   clear;

int   medzera = 8,
      trades;

double menulots;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if(inPadding>inTrigger)Alert("Padding is higher than trigger in break even settings.");
   Comment("Copyright © 2018, David Kurniawan");
   
   if (Digits == 5 || Digits == 3)    // Adjust for five (5) digit brokers.
   {            
      pips2dbl = Point*10; pips2point = 10;pipValue = (MarketInfo(Symbol(),MODE_TICKVALUE))*10;
   } 
   else 
   {    
      pips2dbl = Point;   pips2point = 1;pipValue = (MarketInfo(Symbol(),MODE_TICKVALUE))*1;
   }

   clear = true;

   if(showMenu)
   {  
      DrawMenu();
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   if(showMenu)
   {
      ObjectDelete("name");
      ObjectDelete("Openl");
      ObjectDelete("Open");
      ObjectDelete("Lotsl");
      ObjectDelete("Lots");
      ObjectDelete("Profitl");
      ObjectDelete("Profit");
      ObjectDelete("Profit2");
      ObjectDelete("ProfitSell");
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{

   if(IsNewCandle())CheckMaForTrade();
   if(IsNewCandle())CheckStatoForTrade();

if(bUseBreakEven)BreakEven(inTrigger,inPadding);//Use Breakeven if on.
   if(showMenu)
   {
      ReDrawMenu();
   }

   //Global Variabel Show Profit Or Loss 
   profit = ProfitCheck(); //Hanya Melihat berapa semua profit
   
   //ProfitSell useProfitToClose
   profitSell = ProfitCheckSell();  
   if(useProfitToClose)
   {
      if(profitSell>profitSellToClose)
      {
         if(!AllSymbols)
         {
               if(!CloseDeleteSell()) 
                  clear=false;
         }
      }
   } 
   //ProfitBuy useProfitToClose
   profitBuy = ProfitCheckBuy();  
   if(useProfitToClose)
   {
      if(profitBuy>profitBuyToClose)
      {
         if(!AllSymbols)
         {
               if(!CloseDeleteBuy()) 
                  clear=false;
         }
      }
   } 
    //LossToClosee Sell
   if(useLossToClose == true)
   {
      if(profitSell<-lossToClose)
      {
         if(!AllSymbols)
         {
               if(!CloseDeleteSell()) 
                  clear=false;
         }
      }     
   } 
   //LossToClosee Buy
   if(useLossToClose == true)
   {
      if(profitBuy<-lossToClose)
      {
         if(!AllSymbols)
         {
               if(!CloseDeleteBuy()) 
                  clear=false;
         }
      }     
   } 
//----
   return(0);
//---- 
}
void CheckMaForTrade(){

int res;
double ticksize = MarketInfo(Symbol(),MODE_TICKSIZE);
   if(ticksize == 0.00001 || ticksize== 0.001)
     {
      pips = ticksize*10;
     }
     else
       {
        pips = ticksize;
       }

   double PreviousFast = iMA(NULL,0,FasteMA,FastEmaShift,MODE_EMA,PRICE_MEDIAN,0);
   double CurrentFast = iMA(NULL,0,FasteMA,FastEmaShift,MODE_EMA,PRICE_MEDIAN,1);
   double PreviousSlow = iMA(NULL,0,SloweMA,SlowEmaShift,MODE_EMA,PRICE_MEDIAN,0);
   double CurrentSlow = iMA(NULL,0,SloweMA,SlowEmaShift,MODE_EMA,PRICE_MEDIAN,1);
   if(PreviousFast<PreviousSlow &&CurrentFast>CurrentSlow)
     {
      res = OrderSend(Symbol(),OP_SELL,LotsLots,Bid,3,NormalizeDouble(Ask+stoploss*pips,Digits),NormalizeDouble(Bid-takeprofit*pips,Digits),"",MAGICMA,0,Red);
      return;
     }
   if(PreviousFast>PreviousSlow &&CurrentFast<CurrentSlow)
     {
     res = OrderSend(Symbol(),OP_BUY,LotsLots,Ask,3,NormalizeDouble(Bid-stoploss*pips,Digits),NormalizeDouble(Ask+takeprofit*pips,Digits),"",MAGICMA,0,Blue);
     return;
     
     }
}
void CheckStatoForTrade(){
   int res;
double K_Line = iStochastic(NULL,0,K_Period,D_Period,SlowingStato,MODE_SMA,0,MODE_MAIN,1);
double D_Line = iStochastic(NULL,0,K_Period,D_Period,SlowingStato,MODE_SMA,0,MODE_SIGNAL,1);
double Previus_K_Line = iStochastic(NULL,0,K_Period,D_Period,SlowingStato,MODE_SMA,0,MODE_MAIN,2);
double Previus_D_Line = iStochastic(NULL,0,K_Period,D_Period,SlowingStato,MODE_SMA,0,MODE_SIGNAL,2);
if(Previus_K_Line >= 80)
   if(Previus_K_Line > Previus_D_Line && K_Line  < D_Line)
     {
     res = OrderSend(Symbol(),OP_SELL,1,Bid,3,NormalizeDouble(Bid-stoploss*pips,Digits),NormalizeDouble(Ask+takeprofit*pips,Digits),"",12341,0,Red);
      
     }

if(Previus_K_Line <= 20)
   if(Previus_K_Line < Previus_D_Line && K_Line  > D_Line){
   res = OrderSend(Symbol(),OP_BUY,1,Ask,3,NormalizeDouble(Bid-stoploss*pips,Digits),NormalizeDouble(Ask+takeprofit*pips,Digits),"",12341,0,Blue);
   
   }
}
bool IsNewCandle()
  {
   static int  barsonchart=0;
   if(Bars==barsonchart)
      return(false);
   barsonchart=Bars;
   return(true);
  }

//+------------------------------------------------------------------+
//| Moves stoploss to breakeven after a certain level                |
//+------------------------------------------------------------------+
void BreakEven(double trigger,double padding)
  {
   if(padding>trigger) padding=0.0;
   int total=OrdersTotal();
   bool orderSelected=false,modify=false;
   for(int i=total; i>0; i--)
     {
      orderSelected=OrderSelect(i-1,SELECT_BY_POS);
      if(orderSelected==true)
        {
         if(OrderMagicNumber()==MAGICMA)
           {
            double stoplevel=MarketInfo(NULL,MODE_STOPLEVEL)*Point;
            if(OrderType()==OP_SELL)
              {
               double currentStopLoss=OrderStopLoss();
               double openPrice=OrderOpenPrice();
                  double newStoploss=currentStopLoss;
                  //kondisi nol
                  if(Ask+stoplevel<openPrice -(trigger*Point))
                  {
                     newStoploss=openPrice-(padding*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi satu
                  if(Ask+stoplevel<openPrice -(inTriggerone*Point)){
                     newStoploss=openPrice-(inPaddingone*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi dua
                  if(Ask+stoplevel<openPrice -(inTriggertwo*Point)){
                     newStoploss=openPrice-(inPaddingtwo)*Point;
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi three
                  if(Ask+stoplevel<openPrice -(inTriggerthree*Point)){
                     newStoploss=openPrice-(inPaddingthree*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi empat
                  if(Ask+stoplevel<openPrice -(inTriggerfour*Point))
                  {
                    newStoploss=openPrice-(inPaddingfour*Point);
                  if(newStoploss<currentStopLoss)
                    modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                    Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi lima
                  if(Ask+stoplevel<openPrice -(inTriggerfive*Point))
                    {
                       newStoploss=openPrice-(inPaddingfive*Point);
                    if(newStoploss<currentStopLoss)
                       modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                    if(modify)
                       Print("Sell order #",OrderTicket()," moved to breakeven");
                    }
                   //kondisi enam
                   if(Ask+stoplevel<openPrice -(inTriggerSix*Point))
                  {
                     newStoploss=openPrice-(inPaddingSix*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi tujuh
                  if(Ask+stoplevel<openPrice -(inTriggerSeven*Point))
                  {
                     newStoploss=openPrice-(inPaddingSeven*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi delapan
                  if(Ask+stoplevel<openPrice -(inTriggerEight*Point))
                  {
                     newStoploss=openPrice-(inPaddingEight*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi sembilan
                  if(Ask+stoplevel<openPrice -(inTriggerNine*Point))
                  {
                     newStoploss=openPrice-(inPaddingNine*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi ten
                  if(Ask+stoplevel<openPrice -(inTriggerTen*Point))
                  {
                     newStoploss=openPrice-(inPaddingTen*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi sebelas
                  if(Ask+stoplevel<openPrice -(inTriggerSebelas*Point))
                  {
                     newStoploss=openPrice-(inPaddingSebelas*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi duabelas
                  if(Ask+stoplevel<openPrice -(inTriggerDuaBelas*Point))
                  {
                     newStoploss=openPrice-(inPaddingDuaBelas*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi tigabelas
                  if(Ask+stoplevel<openPrice -(inTriggerTigaBelas*Point))
                  {
                     newStoploss=openPrice-(inPaddingTigaBelas*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi empatbelas
                  if(Ask+stoplevel<openPrice -(inTriggerEmpatBelas*Point))
                  {
                     newStoploss=openPrice-(inPaddingEmpatBelas*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi lima belas
                  if(Ask+stoplevel<openPrice -(inTriggerLimaBelas*Point))
                  {
                     newStoploss=openPrice-(inPaddingLimaBelas*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
                  //kondisi enambelas
                  if(Ask+stoplevel<openPrice -(inTriggerEnamBelas*Point))
                  {
                     newStoploss=openPrice-(inPaddingEnamBelas*Point);
                  if(newStoploss<currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Sell order #",OrderTicket()," moved to breakeven");
                  }
              }
            if(OrderType()==OP_BUY)
              {
               currentStopLoss=OrderStopLoss();
               openPrice=OrderOpenPrice();
                  newStoploss=currentStopLoss;
                  //kondisi nol
                  if(Bid-stoplevel>openPrice+(trigger*Point))
                  {
                     newStoploss=openPrice+(padding*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi nol");
                  }
                  //kondisi satu
                  if(Bid-stoplevel>openPrice+(inTriggerone*Point))
                    {
                     newStoploss=openPrice+(inPaddingone*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi satu");
                    }
                   //kondisi dua
                  if(Bid-stoplevel>openPrice+(inTriggertwo*Point))
                     {
                     newStoploss=openPrice+(inPaddingtwo*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi dua");
                    }
                  //kondisi tiga
                  if(Bid-stoplevel>openPrice+(inTriggerthree*Point))
                     {
                     newStoploss=openPrice+(inPaddingthree*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi tiga");
                    }
                  //kondisi empat
                  if(Bid-stoplevel>openPrice+(inTriggerfour*Point))
                  {
                     newStoploss=openPrice+(inPaddingfour*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi empat");
                  }
                  //kondisi lima
                  if(Bid-stoplevel>openPrice+(inTriggerfive*Point))
                     {
                     newStoploss=openPrice+(inPaddingfive*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi lima");
                    }
                  //kondisi enam
                  if(Bid-stoplevel>openPrice+(inTriggerSix*Point))
                     {
                     newStoploss=openPrice+(inPaddingSix*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi enam");
                    }
                  //kondisi Tujuh
                  if(Bid-stoplevel>openPrice+(inTriggerSeven*Point))
                     {
                     newStoploss=openPrice+(inPaddingSeven*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi Tujuh");
                    }
                   //kondisi Delapan
                  if(Bid-stoplevel>openPrice+(inTriggerEight*Point))
                     {
                     newStoploss=openPrice+(inPaddingEight*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi Delapan");
                    }
                    //kondisi Sembilan
                  if(Bid-stoplevel>openPrice+(inTriggerNine*Point))
                     {
                     newStoploss=openPrice+(inPaddingNine*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi Sembilan");
                    }
                    //kondisi Sepuluh
                  if(Bid-stoplevel>openPrice+(inTriggerTen*Point))
                     {
                     newStoploss=openPrice+(inPaddingTen*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi Sepuluh");
                    }
                    //kondisi Sebelas
                  if(Bid-stoplevel>openPrice+(inTriggerSebelas*Point))
                     {
                     newStoploss=openPrice+(inPaddingSebelas*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi Sebelas");
                    }
                    //kondisi DuaBelas
                  if(Bid-stoplevel>openPrice+(inTriggerDuaBelas*Point))
                     {
                     newStoploss=openPrice+(inPaddingDuaBelas*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi DuaBelas");
                    }
                    //kondisi TigaBelas
                  if(Bid-stoplevel>openPrice+(inTriggerTigaBelas*Point))
                     {
                     newStoploss=openPrice+(inPaddingTigaBelas*Point);
                  if(newStoploss>currentStopLoss)
                     modify=OrderModify(OrderTicket(),openPrice,newStoploss,OrderTakeProfit(),0,clrLavender);
                  if(modify)
                     Print("Buy order #",OrderTicket()," moved to kondisi TigaBelas");
                    }
                    
              }
           }
        }
     }
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////
bool CloseDeleteBuy()
{
    int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) 
         {
            switch(OrderType())
            {
               case OP_BUY       :
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(Symbol(),MODE_BID),maxSlippage,Violet))
                     return(false);
               }break;                  
            }             
         
            
            if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)
               if(!OrderDelete(OrderTicket()))
               { 
                  Print("Error deleting " + OrderType() + " order : ",GetLastError());
                  return (false);
               }
          }
      }
      return (true);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
bool CloseDeleteSell()
{
    int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) 
         {
            switch(OrderType())
            {                 
               case OP_SELL      :
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(Symbol(),MODE_ASK),maxSlippage,Violet))
                     return(false);
               }break;
            }             
         
            
            if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)
               if(!OrderDelete(OrderTicket()))
               { 
                  Print("Error deleting " + OrderType() + " order : ",GetLastError());
                  return (false);
               }
          }
      }
      return (true);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double ProfitCheckSell()
{
   profit=0;
   int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderSymbol()==Symbol())
         if(OrderType()==OP_SELL)
            profit+=OrderProfit();
      }
   return(profit);        
}

double ProfitCheckBuy()
{
   profit=0;
   int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderSymbol()==Symbol())
         if(OrderType()==OP_BUY)
            profit+=OrderProfit();
      }
   return(profit);        
}

double ProfitCheck()
{
   profit=0;
   int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(AllSymbols)
            profit+=OrderProfit();
         else if(OrderSymbol()==Symbol())
            profit+=OrderProfit();
      }
   return(profit);        
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DrawMenu()
{
      ObjectCreate("name",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("Openl",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("Open",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("Lotsl",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("Lots",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("Profitl",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("Profit",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("Profit2",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("ProfitSell",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("Profit3",OBJ_LABEL,0,0,0,0,0);
      ObjectCreate("ProfitBuy",OBJ_LABEL,0,0,0,0,0);
      
      medzera = 8;
       
      trades = Opened();
      menulots = Lots();
     
     ObjectSetText(	"name", "CloseAtProfit", font+1, "Arial",menuColor);
     ObjectSet("name",OBJPROP_XDISTANCE,medzera*font);     
     ObjectSet("name",OBJPROP_YDISTANCE,10+font);
     ObjectSet("name",OBJPROP_CORNER,1);
         
     ObjectSetText("Openl", "Opened trades: ", font, "Arial",menuColor);
     ObjectSet("Openl",OBJPROP_XDISTANCE,medzera*font);     
     ObjectSet("Openl",OBJPROP_YDISTANCE,10+2*(font+2));
     ObjectSet("Openl",OBJPROP_CORNER,1);
     
     ObjectSetText("Open", ""+trades, font, "Arial",variablesColor);
     ObjectSet("Open",OBJPROP_XDISTANCE,3*font);     
     ObjectSet("Open",OBJPROP_YDISTANCE,10+2*(font+2));
     ObjectSet("Open",OBJPROP_CORNER,1);
     
     ObjectSetText("Lotsl", "Lots of opened positions: ", font, "Arial",menuColor);
     ObjectSet("Lotsl",OBJPROP_XDISTANCE,medzera*font);     
     ObjectSet("Lotsl",OBJPROP_YDISTANCE,10+3*(font+2));
     ObjectSet("Lotsl",OBJPROP_CORNER,1);
     
     ObjectSetText("Lots", DoubleToStr(menulots,2), font, "Arial",variablesColor);
     ObjectSet("Lots",OBJPROP_XDISTANCE,3*font);     
     ObjectSet("Lots",OBJPROP_YDISTANCE,10+3*(font+2));
     ObjectSet("Lots",OBJPROP_CORNER,1);
     
     ObjectSetText("Profitl", "Profit of opened positions: ", font, "Arial",menuColor);
     ObjectSet("Profitl",OBJPROP_XDISTANCE,medzera*font);     
     ObjectSet("Profitl",OBJPROP_YDISTANCE,10+4*(font+2));
     ObjectSet("Profitl",OBJPROP_CORNER,1);
     
     ObjectSetText("Profit", DoubleToStr(profit,2), font, "Arial",variablesColor);
     ObjectSet("Profit",OBJPROP_XDISTANCE,3*font);     
     ObjectSet("Profit",OBJPROP_YDISTANCE,10+4*(font+2));
     ObjectSet("Profit",OBJPROP_CORNER,1);
     
     ObjectSetText("Profit2", "ProfitSell of opened positions: ", font, "Arial",menuColor);
     ObjectSet("Profit2",OBJPROP_XDISTANCE,medzera*font);     
     ObjectSet("Profit2",OBJPROP_YDISTANCE,10+5*(font+2));
     ObjectSet("Profit2",OBJPROP_CORNER,1);
     
     ObjectSetText("ProfitSell", DoubleToStr(profitSell,2), font, "Arial",variablesColor);
     ObjectSet("ProfitSell",OBJPROP_XDISTANCE,3*font);     
     ObjectSet("ProfitSell",OBJPROP_YDISTANCE,10+5*(font+2));
     ObjectSet("ProfitSell",OBJPROP_CORNER,1);

     ObjectSetText("Profit3", "ProfitBuy of opened positions: ", font, "Arial",menuColor);
     ObjectSet("Profit3",OBJPROP_XDISTANCE,medzera*font);     
     ObjectSet("Profit3",OBJPROP_YDISTANCE,10+6*(font+2));
     ObjectSet("Profit3",OBJPROP_CORNER,1);
     
     ObjectSetText("ProfitBuy", DoubleToStr(profitBuy,2), font, "Arial",variablesColor);
     ObjectSet("ProfitBuy",OBJPROP_XDISTANCE,3*font);     
     ObjectSet("ProfitBuy",OBJPROP_YDISTANCE,10+6*(font+2));
     ObjectSet("ProfitBuy",OBJPROP_CORNER,1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
bool ReDrawMenu()
{
      medzera = 8;
       
      trades = Opened();
      menulots = Lots();
     
     ObjectSetText("Open", ""+trades, font, "Arial",variablesColor); 
     ObjectSetText("Lots", DoubleToStr(menulots,2), font, "Arial",variablesColor);    
     ObjectSetText("Profit", DoubleToStr(profit,2), font, "Arial",variablesColor);
     ObjectSetText("ProfitSell", DoubleToStr(profitSell,2), font, "Arial",variablesColor);
     ObjectSetText("ProfitBuy", DoubleToStr(profitBuy,2), font, "Arial",variablesColor);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int Opened()
{
    int total  = OrdersTotal();
    int count = 0;
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(AllSymbols)
         {
            if(PendingOrders)
                  count++;
            if(!PendingOrders)
               if(OrderType()==OP_BUY || OrderType()==OP_SELL)
                  count++;
         }
         if(!AllSymbols)
         {
            if(OrderSymbol()==Symbol())
            {
               if(PendingOrders)
                     count++;
               if(!PendingOrders)
                  if(OrderType()==OP_BUY || OrderType()==OP_SELL)
                     count++;
            }
         }
      }
    return (count);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double Lots()
{
    int total  = OrdersTotal();
    double lots = 0;
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {                                   
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(AllSymbols)
         {
            if(PendingOrders)
                  lots+=OrderLots();
            if(!PendingOrders)
               if(OrderType()==OP_BUY || OrderType()==OP_SELL)
                  lots+=OrderLots();
         }
         if(!AllSymbols)
         {
            if(OrderSymbol()==Symbol())
            {
               if(PendingOrders)
                     lots+=OrderLots();
               if(!PendingOrders)
                  if(OrderType()==OP_BUY || OrderType()==OP_SELL)
                     lots+=OrderLots();
            }
         }
      }
    return (lots);
}


