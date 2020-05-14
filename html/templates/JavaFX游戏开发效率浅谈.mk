#### JavaFX游戏开发效率浅谈
这一段时间没事的时候把基于JavaFX的游戏引擎WJFXGameEngine的效率进行优化了一下(个人博客的示例并未重新上传)，简单的2D游戏，在我PC上运行最快可以达到750-800FPS。下面来简单谈谈JavaFX游戏开发上的一些基本问题。



看过JavaFX官方游戏示例BrickBreak的人都可以发现，这个游戏的绘制和逻辑是在Timeline中进行的。JavaFX中的Timeline根据我使用的经验来看，效率不是很高，而且如果数量过多，会很卡。在我游戏引擎中目前的简单的动画是用Timeline实现的，未来会做大改动。

而且之前的教程中，JavaFX简单的游戏框架中讲的也是是用的Timeline。这实际是个很严重的问题。被JavaFX官方示例误导了。



目前我的改动是，使用双线程，一个线程处理绘制，一个线程处理更新操作(这也是很多游戏引擎常用的做法，例如Android游戏引擎AndEngine)。当然，绘制处理必须要在JavaFX MainThread中运行，所以我们使用Platform.runLater来调用绘制操作。虽然它还是在主线程执行，但更新绘制的速度明显更快。之前做的JavaFX游戏示例中，经常出现子弹卡顿等现场，现在不会出现了。


```
	drawThread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				while (isRunning) {
					try {
						Thread.sleep(waitTime);
					} catch (Exception e) {
					}
					Platform.runLater(new Runnable() {
						@Override
						public void run() {
							draw(getGraphicsContext2D());
						}
					});
					if (fpsMaker != null) {
						fpsMaker.makeFPS();
					}
				}
			}
		});
		
		updateThread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				while (isRunning) {
					try {
						Thread.sleep(waitTime);
					} catch (Exception e) {
					}
					update();
				}
			}
		});

```

这个是我的WScreen类里的代码。

线程等待时间waitTime越低的时候，FPS会越快。



FPS快了之后，就有另外一个问题。由于更新操作频繁，如果这样时候你在update等操作里面还依然使用move(4)这样的方法的话，你会发现速度非常的快。



而且由于FPS又不是稳定的，所以我们会发现在不同配置的电脑上运行的情况差别很大，这样，我们就要用到另外一个概念了DeltaTime。



DeltaTime记录的是距离上次Update的时间。我们每次移动的速度* DeltaTime，就可以让我们以不受帧率影响的速率移动了。



当然DeltaTime几乎在所有的游戏引擎或框架中都有这个概念，像我以前用的微软的XNA游戏框架，现在工作的Unity3D开发等。
