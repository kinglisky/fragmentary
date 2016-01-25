var MYAPP = new Object();
window.onload = function () {
    //    MYAPP.SquareList = new Array();
    MYAPP.TdList = document.getElementsByTagName("td");
    MYAPP.clickNum=0;
    initSquare();
    document.getElementById("tryBtn").onclick = function () {
        cleanSquare();
        initSquare();
    }
}

function initSquare() {
    var boolHasList = new Array();
    var length = 4;
    var i, j;
    for (i = 0; i < length; i++) {
        for (j = 0; j < length; j++) {
            var index = i * length + j;
            var randomNum = Math.floor(Math.random() * 16);
            while (boolHasList[randomNum]) {
                randomNum = Math.floor(Math.random() * 16);
            }
            boolHasList[randomNum] = true;
            MYAPP.TdList[index].sqvalue = randomNum;
            MYAPP.TdList[index].row = i;
            MYAPP.TdList[index].col = j;
            MYAPP.TdList[index].index = index;
            MYAPP.TdList[index].firstChild.index = index;
            if (randomNum == 0) {
                MYAPP.emtySquareIndex = index;
                MYAPP.TdList[index].className = "emty";
                MYAPP.TdList[index].firstChild.innerHTML = "";
            } else {
                MYAPP.TdList[index].firstChild.innerHTML = randomNum;
            }
            MYAPP.TdList[index].addEventListener('click', changSquare, false);
        }
    }
}

function changSquare(event) {
    checkWin();
    var index = event.target.index;
    var emtyRow = MYAPP.TdList[MYAPP.emtySquareIndex].row;
    var emtyCol = MYAPP.TdList[MYAPP.emtySquareIndex].col;
    var currRow = MYAPP.TdList[index].row;
    var currCol = MYAPP.TdList[index].col;
    if (index != MYAPP.emtySquareIndex) {
        if ((currRow == emtyRow && (Math.abs(currCol - emtyCol) == 1)) || (currCol == emtyCol && (Math.abs(currRow - emtyRow) == 1))) {
            exchangeSquare(MYAPP.emtySquareIndex, index);
        } else {
            //            alert("点不动啦！");
            return;
        }

    } else {
        //        alert("呵呵点不动");
        return;
    }
}

function checkWin() {
    MYAPP.clickNum++;
    document.getElementById("msg").innerHTML="嘿咻嘿咻..你已经戳了"+MYAPP.clickNum+"下！";
    var winStr = "123456789101112131415";
    var testWinStr="";
    for (var i = 0; i < MYAPP.TdList.length; i++) {
        if(MYAPP.TdList[i].sqvalue!=0){
            testWinStr+=MYAPP.TdList[i].sqvalue;
        }
    }
    if(winStr==testWinStr){
        document.getElementById("msg").innerHTML="你淫了！";
    }
}
function exchangeSquare(emtySquareIndex, beClickSquareIndex) {
    /*其实这里在要改变的只有节点储存的sqvalue每个节点的索引不变*/
    MYAPP.TdList[emtySquareIndex].sqvalue = MYAPP.TdList[beClickSquareIndex].sqvalue;
    MYAPP.TdList[emtySquareIndex].firstChild.innerHTML = MYAPP.TdList[emtySquareIndex].sqvalue;
    MYAPP.TdList[emtySquareIndex].className = "";
    MYAPP.TdList[beClickSquareIndex].sqvalue = 0;
    MYAPP.TdList[beClickSquareIndex].firstChild.innerHTML = "";
    MYAPP.TdList[beClickSquareIndex].className = "emty";
    MYAPP.emtySquareIndex = beClickSquareIndex;
}

function cleanSquare() {
    document.getElementById("msg").innerHTML="开始咯！";
    for (var i = 0; i < MYAPP.TdList.length; i++) {
        MYAPP.TdList[i].className = "";
        while (MYAPP.TdList[i].firstChild.firstChild) {
            MYAPP.TdList[i].firstChild.removeChild(MYAPP.TdList[i].firstChild.firstChild);
        }
    }
}
