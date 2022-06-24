global class HelloWorld  {
   /*private String greeting = 'Hello World';
    public String puglicGreeting = 'My public greeting var';
    
        private String gm = 'gm';
        private String ga = 'ga';
        private String ge = 'ge';
    
   public void printGreeting() {
        System.debug(greeting);     }      
       public void gm() {
        System.debug(gm);      		}  
           public void ge() {
        System.debug(ge);      		}  
           public void ga() {
        System.debug(ga);      		}  
    */
    
    public void printMessage (String msg, Integer x){
	System.debug(msg);
    }
    
    public void getDay(Integer dayNumber){
        String dayString = '';
        switch on dayNumber {
            when 0 {
                dayString= 'Sunday';
                    }
             when 1 {
                dayString= 'Monday';
                    }
            when else {
                dayString = 'Invalid';
            }
        }
    }

}