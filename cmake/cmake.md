# Cmake
## Cmake 課程
[cmake-tutorial](https://cmake.org/cmake-tutorial/) 裡面有逐步教學。

### 第一步
1. CMakeLists.txt 裡面只有下面三行
```
cmake_minimum_required (VERSION 2.6)
project (Tutorial)
add_executable(Tutorial tutorial.cxx)
```
2. tutorial.cxx 檔案的內容如下:
```
// A simple program that computes the square root of a number
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main (int argc, char *argv[])
{
  if (argc < 2)
    {
    fprintf(stdout,"Usage: %s number\n",argv[0]);
    return 1;
    }
  double inputValue = atof(argv[1]);
  double outputValue = sqrt(inputValue);
  fprintf(stdout,"The square root of %g is %g\n",
          inputValue, outputValue);
  return 0;
}
```
將上面兩個檔案方在同一個工作目錄中，切換到該工作目錄後執行
```
cmake .
```
執行時出現下列訊息
```
-- Building for: Visual Studio 15 2017
-- Selecting Windows SDK version 10.0.17763.0 to target Windows 10.0.17134.
-- The C compiler identification is MSVC 19.16.27025.1
-- The CXX compiler identification is MSVC 19.16.27025.1
-- Check for working C compiler: C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Tools/MSVC/14.16.27023/bin/Hostx86/x86/cl.exe
-- Check for working C compiler: C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Tools/MSVC/14.16.27023/bin/Hostx86/x86/cl.exe -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Tools/MSVC/14.16.27023/bin/Hostx86/x86/cl.exe
-- Check for working CXX compiler: C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Tools/MSVC/14.16.27023/bin/Hostx86/x86/cl.exe -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: D:/tmp
```
並產生一大堆檔案。 

cmake 知道電腦中有 VS 2017，自動產生供 VS2017 使用的 Tutorial.sln，後面就可交給 VS2017了。

# A CMake tutorial for Visual C++ developers
這篇[A CMake tutorial for Visual C++ developers](https://www.codeproject.com/Articles/1181455/%2FArticles%2F1181455%2FA-CMake-tutorial-for-Visual-Cplusplus-developers)對初學者很有用，示範了執行檔、動態連結、靜態連結。

學了之後，做了一個簡單的迷你例子。

(1). 假設工作目錄為 cmakedemo，製造子目錄 src

(2). 在 src 裡面放 CMakeLists.txt 與 helloworld.cpp 兩檔案。 CMakeLists.txt 的內容如下：
```
cmake_minimum_required (VERSION 2.6)
project (Tutorial)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/../bin")
add_executable(Tutorial helloworld.cpp)
```
helloworld.cpp 的內容如下：
```
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main ()
{
  double inputValue = atof("7");
  double outputValue = sqrt(inputValue);
  fprintf(stdout,"The square root of %g is %g\n",
          inputValue, outputValue);
  char c;
  scanf("%c", &c);
  return 0;
}
```
(3). 開啟 Visual Studio 2017，`File > Open > Directory > 選取 cmakedemo\src 資料夾`，VS 2017 就進行了 CMakeLists.txt 交代的工作。

此時，VS 2017選單中多出了 CMake選蛋，選取 `CMake > 全部建置`，會在 cmakedemo\bin 產生執行檔 tutorial.exe。

工具列上 `選取啟動項目 > Tutorial.exe`，再按執行就可執行程式。
