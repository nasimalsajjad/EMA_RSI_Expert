//+------------------------------------------------------------------+
//|                                                      EMA_RSI.mq4 |
//|                               Copyright 2017, Md Nasim Al Sajjad |
//|                                          nasimalsajjad@gmail.com |
//+------------------------------------------------------------------+
// This is a trading Robot with EMA and RSI indicators
//It trigars buy when both EMA and RSI Shows bullish and sells when both are bearish.
// It use RISk REWARD ratio 1:3


#property copyright "Copyright 2017, Md Nasim Al Sajjad"
#property link      "nasimalsajjad@gmail.com"
#property version   "1.00"
#property strict
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
input int RSI_Period = 14;
int cRSIsignal = 0;
int maSignal = 0;
double currentRSI = 0.0;
double alternateRSI = 0.0;
int ticketBuy = 0;
int ticketSell = 0;
bool buy = true;
bool sell = true;
void OnTick()
  {
   cRSIsignal = calculateRSI(RSI_Period);
   maSignal = EMASignal();
   if(cRSIsignal == 1 && maSignal == 1 && buy == true){
   // when RSI and EMA is bullish open buy order
   ticketBuy = OrderSend(_Symbol,OP_BUY,0.01,Ask,5,Ask-0.007,Ask+0.021,NULL,0,0,clrGreen);
   buy = false;
   sell = false;
   }else if(cRSIsignal==2 && maSignal == 2 && sell == true){
   ticketSell = OrderSend(_Symbol,OP_SELL,0.01,Bid,5,Bid+0.007,Bid-0.021,NULL,0,0,clrRed);
   buy = false;
   sell = false;
   }
   
   // Reset Order ticket when there is no open order
   if(OrdersTotal() == 0){
   ticketBuy =0;
   ticketSell = 0;
   buy = true;
   sell = true;
   }
   
  }
//+------------------------------------------------------------------+

// Calculate Relative strength index
// 1 is buy signal and 2 is sell signal
int calculateRSI(int p){

int  n= cRSIsignal;

if(n==0){

   currentRSI = iRSI(_Symbol,Period(),p,PRICE_CLOSE,0);
   
   n=updateRSIsignal(); // no need RSICheck function
   }
   else if (n>0){
   alternateRSI = iRSI(_Symbol,Period(),p,PRICE_CLOSE,0);
   n=updateRSIsignal();
   }
return n;
}




int updateRSIsignal(){
   int n=0;
  
  
  if(cRSIsignal == 0 && currentRSI>70){
    n = 2;}
    else if(cRSIsignal ==0 && currentRSI<30){
    n =1;}
    else if(cRSIsignal==2 && alternateRSI<40){
    n = 0;
    }
    else if(cRSIsignal==2 && alternateRSI>40){
    n=2;
    }
    else if(cRSIsignal == 1 && alternateRSI<60){
    n=1;
    }
    else if(cRSIsignal==1 && alternateRSI>60){
    n = 0;
    }
    
    return n;
  }
  
  // calculate Exponential Moving Average
  // 1 is buy signal and 2 is sell signal
int EMASignal(){
int n = 0;
double EMA_Fast = iMA(NULL, NULL,8,0,MODE_EMA,PRICE_CLOSE,0);
double EMA_Slow = iMA(NULL, NULL,26,0,MODE_EMA,PRICE_CLOSE,0);
double EMA_PFast = iMA(NULL, NULL,8,0,MODE_EMA,PRICE_CLOSE,1);
double EMA_PSlow = iMA(NULL, NULL,26,0,MODE_EMA,PRICE_CLOSE,1);
if( maSignal == 0 && EMA_Fast < EMA_Slow && EMA_PFast > EMA_PSlow){
      n =  2;
      }
      else if( maSignal == 0 && EMA_Fast > EMA_Slow && EMA_PFast < EMA_PSlow){
      n= 1;
      }else if ( maSignal == 2 && EMA_Fast < EMA_Slow){
      n= 2;
      }else if (maSignal == 1 && EMA_Fast > EMA_Slow){
      n=1;
      }else{
      n=0;
      }

return n;
}
