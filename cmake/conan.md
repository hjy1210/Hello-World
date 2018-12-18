# conan
conan 是一個 C++ dependency manager.

用來安裝 C++ 套件，例如 opencv, Poco,... 等很好用。

## conan 的安裝
pip install conan

## 用 conan 擷取 opencv 的倚賴性資料供 Visual Studio 2017 使用
參考 [conan getting started](https://docs.conan.io/en/latest/getting_started.html), [integration with visual studio](https://docs.conan.io/en/latest/integrations/visual_studio.html#with-visual-studio-generator), [visual studio generator](https://docs.conan.io/en/latest/reference/generators/visualstudio.html#visualstudio-generator) 這三篇文章，
在選定的工作目錄，用指令
```
conan search opencv* --remote=conan-center
```
得到下列訊息
```
Existing package recipes:

opencv/2.4.13.5@conan/stable
opencv/3.4.3@conan/stable
opencv/4.0.0@conan/stable
```
代表 conan-center 裡面保存有 opencv 三種版本。

可惜沒有dlib。

用指令
```
conan inspect opencv/4.0.0@conan/stable
```
可以得到關於 opencv/4.0.0@conan/stable 的資料

撰寫檔案 conanfile.txt，內容如下：
```
[requires]
Poco/1.9.0@pocoproject/stable
opencv/4.0.0@conan/stable

[generators]
visual_studio
```
代表我們的專案需要 Poco 與 opencv (其中 Poco 是一個加密的套件)，打算用 Visual Studio 來建置專案

用下列指令
```
md debug64
cd debug64
conan install .. -s compiler="Visual Studio" -s compiler.version=15 -s arch=x86_64 -s build_type=Debug
cd ..
```
在 debug64 子目錄裡建立倚賴資料conanbuildinfo.props，供 Visual Studio 2017(compiler.version=15)、64位元版本(arch=x86_64)、
除錯模式(build_type=Debug)使用。

在 Visual Studio 的專案中，叫出屬性管理員，在Debug|x64頁面用加入現有屬性工作表工具選取前述的conanbuildinfo.props，
如此當專案在Debug|x64狀態時，可以使用 Poco 與 OpenCV 這兩個函數庫。下面是一個呼叫的示範程式。
```
#include <iostream>

#include "Poco/MD5Engine.h"
#include "Poco/DigestStream.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#define w 400
using namespace cv;
void MyEllipse(Mat img, double angle);
void MyFilledCircle(Mat img, Point center);
void MyPolygon(Mat img);
void MyLine(Mat img, Point start, Point end);

void pocoTest() {
	Poco::MD5Engine md5;
	Poco::DigestOutputStream ds(md5);
	ds << "abcdefghijklmnopqrstuvwxyz";
	ds.close();
	std::cout << Poco::DigestEngine::digestToHex(md5.digest()) << std::endl;
}

void opencvTest() {
	char atom_window[] = "Drawing 1: Atom";
	char rook_window[] = "Drawing 2: Rook";
	Mat atom_image = Mat::zeros(w, w, CV_8UC3);
	Mat rook_image = Mat::zeros(w, w, CV_8UC3);
	MyEllipse(atom_image, 90);
	MyEllipse(atom_image, 0);
	MyEllipse(atom_image, 45);
	MyEllipse(atom_image, -45);
	MyFilledCircle(atom_image, Point(w / 2, w / 2));
	MyPolygon(rook_image);
	rectangle(rook_image,
		Point(0, 7 * w / 8),
		Point(w, w),
		Scalar(0, 255, 255),
		FILLED,
		LINE_8);
	MyLine(rook_image, Point(0, 15 * w / 16), Point(w, 15 * w / 16));
	MyLine(rook_image, Point(w / 4, 7 * w / 8), Point(w / 4, w));
	MyLine(rook_image, Point(w / 2, 7 * w / 8), Point(w / 2, w));
	MyLine(rook_image, Point(3 * w / 4, 7 * w / 8), Point(3 * w / 4, w));
	imshow(atom_window, atom_image);
	moveWindow(atom_window, 0, 200);
	imshow(rook_window, rook_image);
	moveWindow(rook_window, w, 200);
	waitKey(0);
}


int main(int argc, char** argv)
{
	pocoTest();
	opencvTest();

	return(0);
}

void MyEllipse(Mat img, double angle)
{
	int thickness = 2;
	int lineType = 8;
	ellipse(img,
		Point(w / 2, w / 2),
		Size(w / 4, w / 16),
		angle,
		0,
		360,
		Scalar(255, 0, 0),
		thickness,
		lineType);
}
void MyFilledCircle(Mat img, Point center)
{
	circle(img,
		center,
		w / 32,
		Scalar(0, 0, 255),
		FILLED,
		LINE_8);
}
void MyPolygon(Mat img)
{
	int lineType = LINE_8;
	Point rook_points[1][20];
	rook_points[0][0] = Point(w / 4, 7 * w / 8);
	rook_points[0][1] = Point(3 * w / 4, 7 * w / 8);
	rook_points[0][2] = Point(3 * w / 4, 13 * w / 16);
	rook_points[0][3] = Point(11 * w / 16, 13 * w / 16);
	rook_points[0][4] = Point(19 * w / 32, 3 * w / 8);
	rook_points[0][5] = Point(3 * w / 4, 3 * w / 8);
	rook_points[0][6] = Point(3 * w / 4, w / 8);
	rook_points[0][7] = Point(26 * w / 40, w / 8);
	rook_points[0][8] = Point(26 * w / 40, w / 4);
	rook_points[0][9] = Point(22 * w / 40, w / 4);
	rook_points[0][10] = Point(22 * w / 40, w / 8);
	rook_points[0][11] = Point(18 * w / 40, w / 8);
	rook_points[0][12] = Point(18 * w / 40, w / 4);
	rook_points[0][13] = Point(14 * w / 40, w / 4);
	rook_points[0][14] = Point(14 * w / 40, w / 8);
	rook_points[0][15] = Point(w / 4, w / 8);
	rook_points[0][16] = Point(w / 4, 3 * w / 8);
	rook_points[0][17] = Point(13 * w / 32, 3 * w / 8);
	rook_points[0][18] = Point(5 * w / 16, 13 * w / 16);
	rook_points[0][19] = Point(w / 4, 13 * w / 16);
	const Point* ppt[1] = { rook_points[0] };
	int npt[] = { 20 };
	fillPoly(img,
		ppt,
		npt,
		1,
		Scalar(255, 255, 255),
		lineType);
}
void MyLine(Mat img, Point start, Point end)
{
	int thickness = 2;
	int lineType = LINE_8;
	line(img,
		start,
		end,
		Scalar(0, 0, 0),
		thickness,
		lineType);
}

```

