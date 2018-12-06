## OpenCV
OpenCV (Open Source Computer Vision Library) is released under a BSD license and hence it’s free for both academic and commercial use. It has **C++, Python, Javascript and Java interfaces and supports Windows, Linux, Mac OS, iOS and Android**.
[OpenCV](https://docs.opencv.org/master/index.html)裡面有三個課程
* [OpenCV Tutorials](https://docs.opencv.org/master/d9/df8/tutorial_root.html)
* [OpenCV-Python Tutorials](https://docs.opencv.org/master/d6/d00/tutorial_py_root.html)
* [OpenCV.js Tutorials](https://docs.opencv.org/master/d5/d10/tutorial_js_root.html)
## Javascript+openCV
OpenCV.js Tutorials 所需要的 opencv.js 在[這裡](https://docs.opencv.org/master/opencv.js)
## Python + openCV
* 用 anaconda 安裝 python
* 用指令 conda install opencv 安裝 opencv
* VsCode 安裝 Python extension for Visual Studio Code 插件
* VsCode 用 ctrl+shift+P > python:選擇直譯器，這會保存在 .vscode/settings.json 裡面。
* Vscode 用 ctrl+shift+P > Select default shell  選擇 cmd 當作 shell

## template match - javascript
[OpenCV.js Tutorials > Image Processing > Template Matching](https://docs.opencv.org/master/d8/dd1/tutorial_js_template_matching.html) 示範了模板辨識，是一個簡單的辨識物體功能。本例只考慮平移，若再考慮陰影、光線、旋轉、伸縮等問題，就變得複雜許多，但也變得很有用。
## template match - python
[OpenCV-Python Tutorials > Image Processing > Template Matching](https://docs.opencv.org/master/d4/dc6/tutorial_py_template_matching.html) 示範了模板辨識，只考慮平移因素，使用了'cv.TM_CCOEFF', 'cv.TM_CCOEFF_NORMED', 'cv.TM_CCORR', 'cv.TM_CCORR_NORMED', 'cv.TM_SQDIFF', 'cv.TM_SQDIFF_NORMED' 等六種模式的辨識方法。
* 製作了 `template-match.py` : 以國文卷10-15題的區塊為模板，試看看能不能定位成功。結果是除了'cv.TM_CCORR'法外都成功
* 製作了 `ch-template-match.py` 用'cv.TM_CCOEFF_NORMED'法對卷1目錄裡的10份卷子批次定位，全部成功，列出了定位的座標。
* 從[這裡](https://matplotlib.org/examples/event_handling/keypress_demo.)與[這裡](https://matplotlib.org/examples/event_handling/pick_event_demo.html)下載了`keypress_demo.py`, `pick_event_demo.py`，前者示範keypress事件，後者示範滑鼠事件
* 下一步，用一份卷子，利用鍵盤與滑鼠事件，製作整份卷子所需的模板與位置資料。