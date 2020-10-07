package {

    import flash.events.Event;
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import com.trick7.utils.TeraClock;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class Main extends Sprite {

        public var clock:TeraClock;

        public function Main() {

            // 画面固定
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            // ボタン設定
            _closeBtn.addEventListener(MouseEvent.CLICK, close);
            _minBtn.addEventListener(MouseEvent.CLICK, min);
            _maxBtn.addEventListener(MouseEvent.CLICK, max);
            _restBtn.addEventListener(MouseEvent.CLICK, rest);

            _resizeBtn.addEventListener(MouseEvent.MOUSE_DOWN, resizeApp);

            // ヘッダーの設定
            _header.addEventListener(MouseEvent.MOUSE_DOWN, move);

            // リサイズの設定
            stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, adjust);
            stage.nativeWindow.minSize = new Point(150, 148); //minサイズ指定（これ以上最小化は出来ない）


            clock = new TeraClock();
            clock.addEventListener(TeraClock.SECONDS_CHANGED, secondsListener);
            clock.addEventListener(TeraClock.MINUTES_CHANGED, minutesListener);
            clock.addEventListener(TeraClock.HOURS_CHANGED, hoursListener);

        }

        private function secondsListener(e:Event):void {
            trace(clock.seconds + "秒です。現在：" + clock.hours2 + ":" + clock.minutes2 + ":" + clock.seconds2 + "です。");
            h.rotation = clock.hoursDegree;
            m.rotation = clock.minutesDegree;
            s.rotation = clock.secondsDegree;
        }

        private function minutesListener(e:Event):void {
            trace(clock.minutes + "分です。");
        }

        private function hoursListener(e:Event):void {
            trace(clock.hours + "時です。");
        }

        // 移動関連処理
        private function move(e:MouseEvent):void {
            trace("moved!");
            stage.nativeWindow.startMove();
        }

        // 閉じるボタン押下
        private function close(e:MouseEvent):void {
            trace("close bt click!");
            stage.nativeWindow.close();
        }

        // 最小化ボタン押下
        private function min(e:MouseEvent):void {
            trace("min bt click!");
            stage.nativeWindow.minimize();
        }

        // 最大化ボタン押下
        private function max(e:MouseEvent):void {
            trace("max bt click!");
            stage.nativeWindow.maximize();
        }

        // 元に戻すボタン押下
        private function rest(e:MouseEvent):void {
            trace("rest bt click!");
            stage.nativeWindow.restore();
        }

        // サイズ変更ボタン押下
        private function resizeApp(e:MouseEvent):void {
            trace("resize click!");
            stage.nativeWindow.startResize(NativeWindowResize.BOTTOM_RIGHT);
        }

        // リサイズ処理
        private function adjust(e:NativeWindowBoundsEvent):void {
            // ここでリサイズした（ステージ）サイズに対して、同じ比率でMCを縮めたり、ボタンを移動したりする。
            // なので予め、1つのMCに入れ子にしておくとか、サイズ変更しやすいように作るのがいいかも。
            // 右上にあるボタンなんかは、そのままだと、リサイズした瞬間に見えなく（使えなく）なる
            // mc_bg.width = e.afterBounds.width;s
        }

    }

}
