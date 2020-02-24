 ========= Descriptions of the monthly data ===========

 1. The monthly data come from the Pecanstreet Database: http://www.pecanstreet.org/
    Please visit the Pecanstreet Database website for more details and more data.
    If you use any data from this database (including the dataset in this simulation), please cite the database in your work.
 
 2. The dataset are sampled at 1 sample/minute.

 3. In 3367_2013_05.mat, the variables and the associated meanings are given below:
             AC   --  Air-conditioner power signal (in Watt). 
             CW   --  Power signal of cloth-washer
             DRY  --  Power signal of dryer
             DW   --  Power signal of dish-washer
             EV   --  Power signal of electric vehicle charging load
             FU   --  Power signal of furnace
             OV   --  Power signal of oven
            RANGE --  Power signal of range
             REF  --  Power signal of regrigerator
             WH   --  Power signal of water-heater
       agg_signal --  Power signal of whole-house aggregated signal, i.e. the sum of all the above appliances' power signals
  
     In these variables, the i-th column is samples of the i-th day (1440 samples since the sampling rate is 1 sample/minute) of this month.

     Note that for some houses some of the appliances are not used or do not exist, so the variables are matrices of zeros.

4. In '3367_2013_05', 3367 is the House ID, 2013 is the Year, 05 is the Month.  

