boolean DEBUG_disableAccelerationRampAndMomentum = false;

void DEBUG_printFrameData(long frameStart, long frameEnd) {
  fill(color(360,0,100));
  textSize(16);
  int pressed = 0;
  for (int i = 0; i < 400; i++) {
    if (getInput(i)) {
      String value = String.valueOf((char)i);
      if (i==RIGHT)value="R";
      if (i==LEFT)value="L";
      if (i==UP)value="U";
      if (i==DOWN)value="D";
      text(value, 20*pressed, 20);
      pressed++;
    }
  }
  
  textAlign(LEFT);
  text("f="+state.frame + " count=" + state.objects.size() + " msec="+(System.currentTimeMillis()-state.timeStart) + 
  " rate="+((System.currentTimeMillis()-state.timeStart)/state.frame) + 
  " frame_time=" + (frameEnd-frameStart) + " stage="+state.stage + " game="+state.game, 0, 40);
}
