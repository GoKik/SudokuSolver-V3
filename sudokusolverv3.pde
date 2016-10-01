int sindex = 0; //<>//
int dnum = 0;
int maxd = 0;
long liveTime = 0;
final int SIZE = 4;
/*
String[] raw = {
 "B2 7   F6E   32D",
 "   9B 2     F1 6",
 " A C  7 4 8   E ",
 " 8 3  1   FCA 42",
 "  E     16A   3 ",
 "3        4 F8 6B",
 "   D2    B  74  ",
 " B840  D7 93E   ",
 "   F37 45  90DC ",
 "  C8  A    B4   ",
 "49 5E D        A",
 " D   6C1     7  ",
 "91 E74   F  3 D ",
 " 3   9 2 1  5 0 ",
 "F 4B     3 D1   ",
 "5 D   FE9   2 B4"};
 */
/*
String[] raw = {
  " 56 2  7  EA  9B", 
  "0B  8 9   F  C 5", 
  "89 F E51 3  67D ", 
  " C 36    D  AE  ", 
  " D8 F   04 B   A", 
  "  3  9B5D6C   E4", 
  "F  5A     8902  ", 
  "B     4   37    ", 
  " 3  14    6  A F", 
  " FDC95  3 0  B1 ", 
  "  07  C6  4  5  ", 
  "      F2 A D3 09", 
  " 2   61  C  48  ", 
  "  1  02   73   E", 
  "9  A  EF   6B021", 
  " E      B5   6  "      9
};*/

String[] raw = {
  " 56 2  7  EA  9B", 
  " B  8 9   F  C 5", 
  "89   E 1 3  6 D ", 
  " C 36    D  AE  ", 
  " D8 F   04 B   A", 
  "  3  9 5 6C   E4", 
  "F  5A     8 02  ", 
  "B     4   37    ", 
  " 3  14    6  A F", 
  " FDC95  3 0  B1 ", 
  "  07  C6  4  5  ", 
  "      F2 A D3 09", 
  " 2   61  C  48  ", 
  "  1  02   73   E", 
  "9  A  EF   6B 21", 
  " E      B5   6  "
};
//Sudoku Daten
int[] data;
ArrayList<int[]> dold = new ArrayList<int[]>();
int[][] cdt;
ArrayList<int[][]> cdold = new ArrayList<int[][]>();

void setup() {
  size(1400, 700);
  loadData();
  loadCdt();
  int status = 1;
  long time = millis();
  //1=erfolg
  //2=nicht eindeutig
  //3=fehler=nicht lösbar
  //4=mehrere lösungen
  //5=gelöst
  while (status<3) {
    dold.add(data.clone());
    cdold.add(cdt.clone());
    status = prcCdt(0);
  }
  dold.add(data);
  cdold.add(cdt);
  switch (status) {
  case 3: 
    println("Sudoku nicht lösbar"); 
    break;
  case 4: 
    println("Sudoku hat mehrere Lösungen"); 
    break;
  case 5: 
    println("Sudoku hat eine eindeutige Lösung"); 
    break;
  }
  println("Berechnungszeit: "+(millis()-time)+"ms");
}

void loadData() {
  data = new int[SIZE*SIZE*SIZE*SIZE];
  for (int row=0; row<SIZE*SIZE; row++) {
    for (int column=0; column<SIZE*SIZE; column++) {
      if (raw[row].charAt(column) == 32) {
        data[row*(SIZE*SIZE)+column] = -1;
      } else {
        data[row*(SIZE*SIZE)+column] = raw[row].charAt(column)<65?raw[row].charAt(column)-48:raw[row].charAt(column)-55;
      }
    }
  }
}

void loadCdt() {
  cdt = new int[SIZE*SIZE*SIZE*SIZE][SIZE*SIZE];
  for (int i=0; i<cdt.length; i++) {
    if (data[i] != -1) {
      cdt[i]=null;
    } else {
      cdt[i] = getCdts(i);
      if (cdt[i].length == 0) {
        cdt[i] = null;
      }
    }
  }
  //printarray(cdt);
}

void printarray(int[][] array) {
  for (int i=0; i<array.length; i++) {
    print(i+": ");
    if (array[i]==null) {
      continue;
    }
    for (int j=0; j<array[i].length; j++) {
      print(array[i][j]+" ");
    }
    println();
  }
}

int[] getCdts(int pos) {
  int[] nums = new int[SIZE*SIZE];
  int kbit = SIZE==3?1:0;
  for (int i=0; i<nums.length; i++) {
    nums[i] = i+kbit;
  }
  for (int row=0; row<SIZE*SIZE; row++) {
    if (data[row*(SIZE*SIZE)+pos%(SIZE*SIZE)] != -1) {
      nums[data[row*(SIZE*SIZE)+pos%(SIZE*SIZE)]-kbit] = -1;
    }
  }
  for (int column=0; column<SIZE*SIZE; column++) {
    if (data[pos/(SIZE*SIZE)*(SIZE*SIZE)+column] != -1) {
      nums[data[pos/(SIZE*SIZE)*(SIZE*SIZE)+column]-kbit] = -1;
    }
  }
  //println("Q:"+quad+" P:"+pos);
  for (int field=0; field<SIZE*SIZE; field++) {
    //print("F:"+field+" I: "+(quad/SIZE*(SIZE*SIZE*SIZE)+quad%SIZE*SIZE+(field/SIZE*SIZE*SIZE)+(field%SIZE))+" | ");
    if (data[quad(pos)/SIZE*(SIZE*SIZE*SIZE)+quad(pos)%SIZE*SIZE+(field/SIZE*SIZE*SIZE)+(field%SIZE)] != -1) {
      nums[data[quad(pos)/SIZE*(SIZE*SIZE*SIZE)+quad(pos)%SIZE*SIZE+(field/SIZE*SIZE*SIZE)+(field%SIZE)]-kbit] = -1;
    }
  }
  //println();
  nums = filterarray(nums);
  return nums;
}

void draw() {
  fill(0);

  background(255);
  stroke(0);

  for (int i=0; i<SIZE; i++) {
    line(0, 10+i*160, width, 10+i*160);
  }
  for (int i=0; i<SIZE; i++) {
    line(30+i*160, 0, 30+i*160, height);
  }
  for (int i=0; i<data.length; i++) {
    textSize(20);
    fill(0, 50);
    text(i, 40+i%(SIZE*SIZE)*40, 40+i/(SIZE*SIZE)*40);
    if (data[i] != -1) {
      textSize(15);
      fill(0);
      text(data[i], 40+i%(SIZE*SIZE)*40, 40+i/(SIZE*SIZE)*40);
    } else if (cdt[i] != null) {
      textSize(10);
      fill(255, 0, 0);
      for (int j=0; j<cdt[i].length; j++) {
        if (dnum==cdt[i][j] || dnum > SIZE*SIZE) {
          text(cdt[i][j], 40+i%(SIZE*SIZE)*40+(j%2)*15, 30+i/(SIZE*SIZE)*40+(j/2)%2*15);
        }
      }
    }
  }
  translate(width/2, 0);
  for (int i=0; i<SIZE; i++) {
    line(0, 10+i*160, width, 10+i*160);
  }
  for (int i=0; i<SIZE; i++) {
    line(30+i*160, 0, 30+i*160, height);
  }
  if (sindex<dold.size()) {
    for (int i=0; i<dold.get(sindex).length; i++) {
      textSize(20);
      fill(0, 50);
      text(i, 40+i%(SIZE*SIZE)*40, 40+i/(SIZE*SIZE)*40);
      if (dold.get(sindex)[i] != -1) {
        textSize(15);
        fill(0);
        text(dold.get(sindex)[i], 40+i%(SIZE*SIZE)*40, 40+i/(SIZE*SIZE)*40);
      } else if (cdold.get(sindex)[i] != null) {
        textSize(10); //<>//
        fill(255, 0, 0);
        for (int j=0; j<cdold.get(sindex)[i].length; j++) { //<>//
          text(cdold.get(sindex)[i][j], 40+i%(SIZE*SIZE)*40+(j%2)*15, 30+i/(SIZE*SIZE)*40+(j/2)%2*15);
        } //<>//
      }
    }
  }
}

int prcCdt(int d) {
  if (liveTime+10000<millis()) {
    println("Time: "+(millis()/1000/60)+"m "+(millis()/1000%60)+"s");
    liveTime = millis();
  }
  if (!singleCdt()) {
    if (!onlyCdt()) {
      if (!dblPair()) {
        if (!dblTwin()) {
          if (hasError()) {
            return 3;
          } else if (isFinished()) {
            return 5;
          } else {
            return defineSolution(d);
          }
        }
      }
    }
  }
  return hasError()?3:isFinished()?5:1;
}

int defineSolution(int d) {
  if (d>maxd) {
    maxd=d;
    println("D: "+d);
  }
  ArrayList<int[]> twins = new ArrayList<int[]>();
  ArrayList<Integer> ids = new ArrayList<Integer>();
  for (int row=0; row<SIZE*SIZE; row++) {
    for (int i=0; i<SIZE*SIZE; i++) {
      for (int column=0; column<SIZE*SIZE; column++) {
        if (cdt[row*(SIZE*SIZE)+column]!=null) {
          for (int j=0; j<cdt[row*(SIZE*SIZE)+column].length; j++) {
            if (cdt[row*(SIZE*SIZE)+column][j]==i) {
              ids.add(row*(SIZE*SIZE)+column);
            }
          }
        }
      }
      if (ids.size()==2) {
        twins.add(new int[3]);
        twins.get(twins.size()-1)[0]=i;
        twins.get(twins.size()-1)[1]=ids.get(0);
        twins.get(twins.size()-1)[2]=ids.get(1);
      }
      ids.clear();
    }
  }
  for (int column=0; column<SIZE*SIZE; column++) {
    for (int i=0; i<SIZE*SIZE; i++) {
      for (int row=0; row<SIZE*SIZE; row++) {
        if (cdt[row*(SIZE*SIZE)+column]!=null) {
          for (int j=0; j<cdt[row*(SIZE*SIZE)+column].length; j++) {
            if (cdt[row*(SIZE*SIZE)+column][j]==i) {
              ids.add(row*(SIZE*SIZE)+column);
            }
          }
        }
      }
      if (ids.size()==2) {
        twins.add(new int[3]);
        twins.get(twins.size()-1)[0]=i;
        twins.get(twins.size()-1)[1]=ids.get(0);
        twins.get(twins.size()-1)[2]=ids.get(1);
      }
      ids.clear();
    }
  }
  for (int quad=0; quad<SIZE*SIZE; quad++) {
    for (int i=0; i<SIZE*SIZE; i++) {
      for (int field=0; field<SIZE*SIZE; field++) {
        int id = quad/SIZE*SIZE*SIZE*SIZE+quad%SIZE*SIZE+field/SIZE*SIZE*SIZE+field%SIZE;
        if (cdt[id]!=null) {
          for (int j=0; j<cdt[id].length; j++) {
            if (cdt[id][j]==i) {
              ids.add(id);
            } //<>//
          }
        }
      }
      if (ids.size()==2) {
        twins.add(new int[3]);
        twins.get(twins.size()-1)[0]=i;
        twins.get(twins.size()-1)[1]=ids.get(0);
        twins.get(twins.size()-1)[2]=ids.get(1);
      }
      ids.clear();
    }
  }
  if (twins.size()==0) {
    return 3;
  }
  int[] datasave = data.clone();
  int[][] cdtsave = cdt.clone();
  int[] sdata = data.clone();
  int[][] scdt = cdt.clone();
  for (int i=0; i<twins.size(); i++) {
    //println("D"+d+" T"+i+": "+twins.get(0)[0]+" "+twins.get(0)[1]+" "+twins.get(0)[2]);
    data[twins.get(i)[1]] = twins.get(i)[0];
    cdt[twins.get(i)[1]]=null;
    updateCdt(twins.get(i)[1]);
    int statusa=1;
    while (statusa<3) {
      statusa=prcCdt(d+1);
    }
    if (statusa==5) {
      sdata=data.clone();
      scdt = cdt.clone();
    }
    data = datasave.clone();
    cdt = cdtsave.clone();
    data[twins.get(i)[2]] = twins.get(i)[0];
    cdt[twins.get(i)[2]]=null;
    updateCdt(twins.get(i)[2]);
    int statusb=1;
    while (statusb<3) {
      statusb=prcCdt(d+1);
    }
    if (statusb==5) {
      sdata=data.clone();
      scdt = cdt.clone();
    }
    data = datasave.clone();
    cdt = cdtsave.clone();
    //println("SA: "+statusa+" SB: "+statusb);
    if ((statusa==5&&statusb==3)||(statusa==3&&statusb==5)) {
      data = sdata;
      cdt = scdt;
      return 5;
    } else if (statusa==3&&statusb==3) {
      return 3;
    }
  }
  return 4;
}

boolean isFinished() {
  for (int i=0; i<data.length; i++) {
    if (data[i]==-1) {
      return false;
    }
  }
  return true;
}

boolean hasError() {
  for (int i=0; i<data.length; i++) {
    if (data[i]==-1&&cdt[i]==null) {
      return true;
    }
  }
  return false;
}

boolean singleCdt() {
  for (int i=0; i<cdt.length; i++) {
    if (cdt[i] != null && cdt[i].length==1) {
      data[i] = cdt[i][0];
      cdt[i] = null;
      updateCdt(i);
      //println("SingleCdt: Id: "+i+" D: "+data[i]);
      return true;
    }
  }
  return false;
}

boolean onlyCdt() {
  int[][] tmpCdt = new int[SIZE*SIZE][2];
  int kbit = SIZE==3?1:0;
  for (int row=0; row<SIZE*SIZE; row++) {
    tmpCdt = new int[SIZE*SIZE][2];
    for (int column=0; column<SIZE*SIZE; column++) {
      if (cdt[row*(SIZE*SIZE)+column]!=null) {
        for (int i=0; i<cdt[row*(SIZE*SIZE)+column].length; i++) {
          tmpCdt[cdt[row*(SIZE*SIZE)+column][i]-kbit][0] = row*(SIZE*SIZE)+column;
          tmpCdt[cdt[row*(SIZE*SIZE)+column][i]-kbit][1]++;
        }
      }
    }
    for (int i=0; i<tmpCdt.length; i++) {
      if (tmpCdt[i][1]==1) {
        data[tmpCdt[i][0]] = i+kbit;
        cdt[tmpCdt[i][0]] = null;
        updateCdt(tmpCdt[i][0]);
        //println("OnlyCdt: Id: "+tmpCdt[i][0]+" D: "+data[tmpCdt[i][0]]);
        return true;
      }
    }
  }
  for (int column=0; column<SIZE*SIZE; column++) {
    tmpCdt = new int[SIZE*SIZE][3];
    for (int row=0; row<SIZE*SIZE; row++) {
      if (cdt[row*(SIZE*SIZE)+column]!=null) {
        for (int i=0; i<cdt[row*(SIZE*SIZE)+column].length; i++) {
          tmpCdt[cdt[row*(SIZE*SIZE)+column][i]-kbit][0] = row*(SIZE*SIZE)+column;
          tmpCdt[cdt[row*(SIZE*SIZE)+column][i]-kbit][1]++;
        }
      }
    }
    for (int i=0; i<tmpCdt.length; i++) {
      if (tmpCdt[i][1]==1) {
        data[tmpCdt[i][0]] = i+kbit;
        cdt[tmpCdt[i][0]] = null;
        updateCdt(tmpCdt[i][0]);
        //println("OnlyCdt: Id: "+tmpCdt[i][0]+" D: "+data[tmpCdt[i][0]]);
        return true;
      }
    }
  }
  for (int quad=0; quad<SIZE*SIZE; quad++) {
    tmpCdt = new int[SIZE*SIZE][3];
    for (int field=0; field<SIZE*SIZE; field++) {
      int id = quad/SIZE*SIZE*SIZE*SIZE+quad%SIZE*SIZE+field/SIZE*SIZE*SIZE+field%SIZE;
      if (cdt[id]!=null) {
        for (int i=0; i<cdt[id].length; i++) {
          tmpCdt[cdt[id][i]-kbit][0] = id;
          tmpCdt[cdt[id][i]-kbit][1]++;
        }
      }
    }
    for (int i=0; i<tmpCdt.length; i++) {
      if (tmpCdt[i][1]==1) {
        data[tmpCdt[i][0]] = i+kbit;
        cdt[tmpCdt[i][0]] = null;
        updateCdt(tmpCdt[i][0]);
        //println("OnlyCdt: Id: "+tmpCdt[i][0]+" D: "+data[tmpCdt[i][0]]);
        return true;
      }
    }
  }
  return false;
}

void updateCdt(int ind) {
  int row = ind/(SIZE*SIZE);
  int column = ind%(SIZE*SIZE);
  int quad = quad(ind);
  for (int c=0; c<SIZE*SIZE; c++) {
    if (cdt[row*(SIZE*SIZE)+c]!=null) {
      for (int i=0; i<cdt[row*(SIZE*SIZE)+c].length; i++) {
        if (cdt[row*(SIZE*SIZE)+c][i]==data[ind]) {
          cdt[row*(SIZE*SIZE)+c] = removeCdt(cdt[row*(SIZE*SIZE)+c], i);
          break;
        }
      }
    }
  }
  for (int r=0; r<SIZE*SIZE; r++) {
    if (cdt[r*(SIZE*SIZE)+column]!=null) {
      for (int i=0; i<cdt[r*(SIZE*SIZE)+column].length; i++) {
        if (cdt[r*(SIZE*SIZE)+column][i]==data[ind]) {
          cdt[r*(SIZE*SIZE)+column] = removeCdt(cdt[r*(SIZE*SIZE)+column], i);
          break;
        }
      }
    }
  }
  for (int field=0; field<SIZE*SIZE; field++) {
    int id = quad/SIZE*(SIZE*SIZE*SIZE)+quad%SIZE*SIZE+(field/SIZE*SIZE*SIZE)+(field%SIZE);
    if (cdt[id]!=null) {
      for (int i=0; i<cdt[id].length; i++) {
        if (cdt[id][i]==data[ind]) {
          cdt[id] = removeCdt(cdt[id], i);
          break;
        }
      }
    }
  }
}

boolean dblPair() {
  boolean chgd = false;
  ArrayList<Integer> ids = new ArrayList<Integer>();
  int kbit=SIZE==3?1:0;
  for (int row=0; row<SIZE*SIZE; row++) {
    for (int i=0; i<SIZE*SIZE; i++) {
      for (int column=0; column<SIZE*SIZE; column++) {
        if (cdt[row*(SIZE*SIZE)+column]!=null) {
          for (int j=0; j<cdt[row*(SIZE*SIZE)+column].length; j++) {
            if (cdt[row*(SIZE*SIZE)+column][j]==i) {
              ids.add(row*(SIZE*SIZE)+column);
            }
          }
        }
      }
      if (ids.size()==2) {
        if (quad(ids.get(0)) == quad(ids.get(1))) {
          chgd = filterQuad(quad(ids.get(0)), i, ids.get(0), ids.get(1))?true:chgd;
          if (chgd) {
            return true;
          }
        }
      }
      ids.clear();
    }
  }
  for (int column=0; column<SIZE*SIZE; column++) {
    for (int i=0; i<SIZE*SIZE; i++) {
      for (int row=0; row<SIZE*SIZE; row++) {
        if (cdt[row*(SIZE*SIZE)+column]!=null) {
          for (int j=0; j<cdt[row*(SIZE*SIZE)+column].length; j++) {
            if (cdt[row*(SIZE*SIZE)+column][j]==i) {
              ids.add(row*(SIZE*SIZE)+column);
            }
          }
        }
      }
      if (ids.size()==2) {
        if (quad(ids.get(0)) == quad(ids.get(1))) {
          chgd = filterQuad(quad(ids.get(0)), i, ids.get(0), ids.get(1))?true:chgd;
          if (chgd) {
            return true;
          }
        }
      }
      ids.clear();
    }
  }
  for (int quad=0; quad<SIZE*SIZE; quad++) {
    for (int i=0; i<SIZE*SIZE; i++) {
      for (int field=0; field<SIZE*SIZE; field++) {
        int id = quad/SIZE*SIZE*SIZE*SIZE+quad%SIZE*SIZE+field/SIZE*SIZE*SIZE+field%SIZE;
        if (cdt[id]!=null) {
          for (int j=0; j<cdt[id].length; j++) {
            if (cdt[id][j]==i) {
              ids.add(id);
            }
          }
        }
      }
      if (ids.size()==2) {
        if (ids.get(0)/(SIZE*SIZE) == ids.get(1)/(SIZE*SIZE)) {
          chgd = filterRow(ids.get(0)/(SIZE*SIZE), i, ids.get(0), ids.get(1))?true:chgd;
          if (chgd) {
            return true;
          }
        } else if (ids.get(0)%(SIZE*SIZE) == ids.get(1)%(SIZE*SIZE)) {
          chgd = filterColumn(ids.get(0)%(SIZE*SIZE), i, ids.get(0), ids.get(1))?true:chgd;
          if (chgd) {
            return true;
          }
        }
      }
      ids.clear();
    }
  }
  return chgd;
}

boolean filterQuad(int quad, int num, int ext1, int ext2) {
  boolean sc = false;
  for (int field=0; field<SIZE*SIZE; field++) {
    int id = quad/SIZE*(SIZE*SIZE*SIZE)+quad%SIZE*SIZE+(field/SIZE*SIZE*SIZE)+(field%SIZE);
    if (id==ext1 || id==ext2 || cdt[id]==null) {
      continue;
    }
    for (int i=0; i<cdt[id].length; i++) {
      if (cdt[id][i] == num) {
        cdt[id] = removeCdt(cdt[id], i);
        sc = true;
      }
    }
  }
  return sc;
}

boolean filterRow(int row, int num, int ext1, int ext2) {
  boolean sc = false;
  for (int column=0; column<SIZE*SIZE; column++) {
    int id = row*(SIZE*SIZE)+column;
    if (id==ext1 || id==ext2 || cdt[id]==null) {
      continue;
    }
    for (int i=0; i<cdt[id].length; i++) {
      if (cdt[id][i] == num) {
        cdt[id] = removeCdt(cdt[id], i);
        sc = true;
      }
    }
  }
  return sc;
}

boolean filterColumn(int column, int num, int ext1, int ext2) {
  boolean sc = false;
  for (int row=0; row<SIZE*SIZE; row++) {
    int id = row*(SIZE*SIZE)+column;
    if (id==ext1 || id==ext2 || cdt[id]==null) {
      continue;
    }
    for (int i=0; i<cdt[id].length; i++) {
      if (cdt[id][i] == num) {
        cdt[id] = removeCdt(cdt[id], i);
        sc = true;
      }
    }
  }
  return sc;
}

boolean dblTwin() {
  ArrayList<int[]> twins = new ArrayList<int[]>();
  boolean chgd = false;
  for (int row=0; row<SIZE*SIZE; row++) {
    for (int column=0; column<SIZE*SIZE; column++) {
      selectTwins(row*(SIZE*SIZE)+column, twins);
    }
    //println("Row: "+row+" T: "+twins.size());
    chgd = checkTwins(twins, 0)?true:chgd;
    twins.clear();
  }
  for (int column=0; column<SIZE*SIZE; column++) {
    for (int row=0; row<SIZE*SIZE; row++) {
      selectTwins(row*(SIZE*SIZE)+column, twins);
    }
    //println("Column: "+column+" T: "+twins.size());
    chgd = checkTwins(twins, 1)?true:chgd;
    twins.clear();
  }
  for (int quad=0; quad<SIZE*SIZE; quad++) {
    for (int field=0; field<SIZE*SIZE; field++) {
      selectTwins(quad/SIZE*(SIZE*SIZE*SIZE)+quad%SIZE*SIZE+(field/SIZE*SIZE*SIZE)+(field%SIZE), twins);
    }
    //println("Quad: "+quad+" T: "+twins.size());
    chgd = checkTwins(twins, 2)?true:chgd;
    twins.clear();
  }
  return chgd;
}

boolean checkTwins(ArrayList<int[]> twins, int mode) {
  ArrayList<ArrayList<Integer>> cnttwins = new ArrayList<ArrayList<Integer>>();
  for (int i=0; i<twins.size(); i++) {
    int ind = -1;
    for (int j=0; j<cnttwins.size(); j++) {
      if (cnttwins.get(j).get(0) == twins.get(i)[1] && cnttwins.get(j).get(1) == twins.get(i)[2]) {
        ind = j;
      }
    }
    if (ind!=-1) {
      cnttwins.get(ind).add(twins.get(i)[0]);
    } else {
      cnttwins.add(new ArrayList<Integer>());
      cnttwins.get(cnttwins.size()-1).add(twins.get(i)[1]);
      cnttwins.get(cnttwins.size()-1).add(twins.get(i)[2]);
      cnttwins.get(cnttwins.size()-1).add(twins.get(i)[0]);
    }
  }
  boolean chgd = false;
  for (int i=0; i<cnttwins.size(); i++) {
    if (cnttwins.get(i).size() == 4) {
      if (!numInTwin(cnttwins.get(i).get(0), cnttwins, i) && !numInTwin(cnttwins.get(i).get(1), cnttwins, i)) {
        if (cdt[cnttwins.get(i).get(2)].length > 2) {
          cdt[cnttwins.get(i).get(2)] = new int[2];
          cdt[cnttwins.get(i).get(2)][0] = cnttwins.get(i).get(0);
          cdt[cnttwins.get(i).get(2)][1] = cnttwins.get(i).get(1);
          //println("Updated Cdts of "+cnttwins.get(i).get(2));
          chgd = true;
        }
        if (cdt[cnttwins.get(i).get(3)].length > 2) {
          cdt[cnttwins.get(i).get(3)] = new int[2];
          cdt[cnttwins.get(i).get(3)][0] = cnttwins.get(i).get(0);
          cdt[cnttwins.get(i).get(3)][1] = cnttwins.get(i).get(1);
          //println("Updated Cdts of "+cnttwins.get(i).get(3));
          chgd = true;
        }
        chgd = removeTwinRest(cnttwins.get(i).get(2), cnttwins.get(i).get(3), mode)?true:chgd;
      } else {
        //println("Failed for "+cnttwins.get(i).get(0)+" "+cnttwins.get(i).get(1));
      }
    }
  }
  return chgd;
}


boolean removeTwinRest(int t1, int t2, int mode) {
  boolean chgd = false;
  if (mode!=0 && t1/(SIZE*SIZE)==t2/(SIZE*SIZE)) {
    int row = t1/(SIZE*SIZE);
    int id=0;
    for (int column=0; column<SIZE*SIZE; column++) {
      id=row*(SIZE*SIZE)+column;
      if (cdt[id]!=null&&id!=t1&&id!=t2) {
        for (int i=0; i<cdt[id].length; i++) {
          if (cdt[id][i] == cdt[t1][0] || cdt[id][i] == cdt[t1][1]) {
            cdt[id] = removeCdt(cdt[id], i);
            chgd = true;
          }
        }
      }
    }
  }
  if (mode!=1 && t1%(SIZE*SIZE)==t2%(SIZE*SIZE)) {
    int column = t1%(SIZE*SIZE);
    int id=0;
    for (int row=0; row<SIZE*SIZE; row++) {
      id=row*(SIZE*SIZE)+column;
      if (cdt[id]!=null&&id!=t1&&id!=t2) {
        for (int i=0; i<cdt[id].length; i++) {
          if (cdt[id][i] == cdt[t1][0] || cdt[id][i] == cdt[t1][1]) {
            cdt[id] = removeCdt(cdt[id], i);
            chgd = true;
          }
        }
      }
    }
  }
  if (mode!=2 && quad(t1)==quad(t2)) {
    int id=0;
    for (int field=0; field<SIZE*SIZE; field++) {
      id=quad(t1)/SIZE*(SIZE*SIZE*SIZE)+quad(t1)%SIZE*SIZE+(field/SIZE*SIZE*SIZE)+(field%SIZE);
      if (cdt[id]!=null&&id!=t1&&id!=t2) {
        for (int i=0; i<cdt[id].length; i++) {
          if (cdt[id][i] == cdt[t1][0] || cdt[id][i] == cdt[t1][1]) {
            cdt[id] = removeCdt(cdt[id], i);
            chgd = true;
          }
        }
      }
    }
  }
  return chgd;
}

int quad(int a) {
  return ((a/(SIZE*SIZE)/SIZE*SIZE)+(a%(SIZE*SIZE)/SIZE));
}

int[] removeCdt(int[] array, int id) {
  int[] tmp = new int[array.length-1];
  int ind = 0;
  for (int i=0; i<array.length; i++) {
    if (i==id) {
      continue;
    }
    tmp[ind] = array[i];
    ind++;
  }
  return tmp;
}

boolean numInTwin(int num, ArrayList<ArrayList<Integer>> list, int except) {
  //println("Look for num: "+num);
  for (int i=0; i<list.size(); i++) {
    if (i==except) {
      continue;
    }
    /*println("I: "+i+" A: "+list.get(i).get(0)+" B: "+list.get(i).get(1)+" E1: "+list.get(except).get(2)+" E2: "+list.get(except).get(3));
     print("Array: ");
     for (int j=0; j<list.get(i).size(); j++) {
     print(list.get(i).get(j)+" ");
     }
     println();*/
    if ((list.get(i).get(0) == num || list.get(i).get(1) == num) && hasId(list.get(i), list.get(except))) {
      //println("Found");
      return true;
    } else {
      //println("Not Found");
    }
  }
  return false;
}

boolean hasId(ArrayList<Integer> array, ArrayList<Integer> id) {
  //print("ID1: "+id.get(2)+" ID2: "+id.get(3)+" A: ");
  for (int i=2; i<array.size(); i++) {
    //print(array.get(i)+" ");
    if (array.get(i) != id.get(2) && array.get(i) != id.get(3)) {
      //println(" got");
      return true;
    }
  }
  //println(" not");
  return false;
}

void selectTwins(int ind, ArrayList<int[]> list) {
  if (cdt[ind]!=null) {
    for (int i=0; i<cdt[ind].length; i++) {
      for (int j=i+1; j<cdt[ind].length; j++) {
        list.add(new int[3]); 
        list.get(list.size()-1)[0] = ind; 
        list.get(list.size()-1)[1] = cdt[ind][i]; 
        list.get(list.size()-1)[2] = cdt[ind][j];
      }
    }
  }
}

int[][] filterarray(int[][] array) {
  int size = 0; 
  for (int i=0; i<array.length; i++) {
    if (array[i]!=null) {
      size++;
    }
  }
  int[][] res = new int[size][]; 
  int index = 0; 
  for (int i=0; i<array.length; i++) {
    if (array[i]!=null) {
      res[index]=array[i]; 
      index++;
    }
  }
  return res;
}


int[] filterarray(int[] array) {
  int size = 0; 
  for (int i=0; i<array.length; i++) {
    if (array[i]!=-1) {
      size++;
    }
  }
  int[] res = new int[size]; 
  int index = 0; 
  for (int i=0; i<array.length; i++) {
    if (array[i]!=-1) {
      res[index]=array[i]; 
      index++;
    }
  }
  return res;
}


void keyPressed() {
  if (key=='w') {
    sindex++;
  } 
  if (key=='s') {
    sindex--;
  }
  if (key=='a') {
    dnum++;
  }
  if (key=='d') {
    dnum--;
  }
}