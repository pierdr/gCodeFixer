String[] lines;
ArrayList<String> list = new ArrayList<String>();

String prevCoordX, prevCoordY, currentCoordX, currentCoordY;
int servoIndex = 0;
int prevIndex = 0;

void setup()
{
  lines =   loadStrings("input.gcode");
  //Copy to ArrayList
   for (int i = 0 ; i < lines.length; i++){
     list.add(lines[i]);
   }
   
  println("there are " + lines.length + " lines");
  //ADD PAUSE WHEN NEED TO LIFT SERVO
  for (int i = 0 ; i < list.size(); i++) {
    
    if(list.get(i).indexOf("M05 S0")==0)
    {
      servoIndex = i;
    }
    if(list.get(i).indexOf("G1")==0 && list.get(i).indexOf("X")!=-1)
    {
      int XPos = list.get(i).indexOf("X");
      int YPos = list.get(i).indexOf("Y");
       println(list.get(i) + " "+ XPos +" "+YPos);
      currentCoordX = list.get(i).substring(XPos,list.get(i).indexOf(" ",XPos));
      currentCoordY = list.get(i).substring(YPos);
      if(!currentCoordX.equals( prevCoordX) && !currentCoordY.equals( prevCoordY))
      {
        if(servoIndex>prevIndex)
        {
          list.add(servoIndex+1,"G4 P0.20000000298023224" );
          i++;
        }
      }
      
      prevCoordX = currentCoordX;
      prevCoordY = currentCoordY;
      prevIndex = i;
    }
  }
  //REMOVE PAUSE WHEN NO NEED TO USE SERVO
  servoIndex = 0;
  prevIndex = 0;
  for (int i = 0 ; i < list.size(); i++) {
    
    if(list.get(i).indexOf("M05 S0")==0)
    {
      servoIndex = i;
    }
    if(list.get(i).indexOf("G1")==0 && list.get(i).indexOf("X")!=-1)
    {
      int XPos = list.get(i).indexOf("X");
      int YPos = list.get(i).indexOf("Y");
       println(list.get(i) + " "+ XPos +" "+YPos);
      currentCoordX = list.get(i).substring(XPos,list.get(i).indexOf(" ",XPos));
      currentCoordY = list.get(i).substring(YPos);
      if(currentCoordX.equals( prevCoordX) && currentCoordY.equals( prevCoordY))
      {
       list.remove(i+1);
       list.remove(i+1);
       list.remove(i+1);
        list.remove(i);
        list.remove(i-1);
        list.remove(i-2);
        list.remove(i-3);
        i=i-4;
      }
      
      prevCoordX = currentCoordX;
      prevCoordY = currentCoordY;
      prevIndex = i;
    }
  }
 
  String outputString[] = new String[list.size()];
  
  for (int i=0;i<list.size();i++)
  {
      outputString[i] = list.get(i);
  }
  
  // Writes the strings to a file, each on a separate line
  saveStrings("output.gcode", outputString);

}
