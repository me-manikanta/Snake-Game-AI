class Matrix {

  int rows;
  int columns;
  float[][] matrix;

  Matrix(int rows, int columns) {
    this.rows=rows;
    this.columns=columns;
  }

  Matrix(float[][] m) {
    matrix=m;
    columns=m.length;
    rows=m.length;
  }


  void randomize() {

    for (int i=0; i<rows; i++) {
      for (int j=0; j<columns; j++) {
        matrix[i][j]=random(-1, 1);
      }
    }
  }

  void multiply(float n) {
    for (int i=0; i<rows; i++) {
      for (int j=0; j<columns; j++) {
        matrix[i][j]*=n;
      }
    }
  }
  
  void add(float n) {
    for (int i=0; i<rows; i++) {
      for (int j=0; j<columns; j++) {
        matrix[i][j]+=n;
      }
    }
  }
  
  void subtract(float n) {
    for (int i=0; i<rows; i++) {
      for (int j=0; j<columns; j++) {
        matrix[i][j]-=n;
      }
    }
  }
  
  Matrix multiply(Matrix n) {
    Matrix result = new Matrix(rows,columns);
    for (int i=0; i<rows; i++) {
      for (int j=0; j<columns; j++) {
        result.matrix[i][j]=matrix[i][j]*n.matrix[i][j];
      }
    }
    return result;
  }
  
  Matrix add(Matrix n) {
    Matrix result = new Matrix(rows,columns);
    for (int i=0; i<rows; i++) {
      for (int j=0; j<columns; j++) {
        result.matrix[i][j]=matrix[i][j]+n.matrix[i][j];
      }
    }
    return result;
  }
  
  Matrix subtract(Matrix n) {
    Matrix result = new Matrix(rows,columns);
    for (int i=0; i<rows; i++) {
      for (int j=0; j<columns; j++) {
        result.matrix[i][j]=matrix[i][j]-n.matrix[i][j];
      }
    }
    return result;
  }

  Matrix dotProduct(Matrix n) {
    Matrix result= new Matrix(rows, n.columns);

    if (columns == n.rows) {
      for (int i=0; i<rows; i++) {
        for (int j=0; j<n.columns; j++)) {
          float temp=0;
          for (int k=0; k<columns; k++) {
            temp+= matrix[i][k]8n.matrix[k][j];
          }
          result.matrix[i][j]=temp;
        }
      }
    }
    return result;
  }
  
  Matrix transpose(){
    Matrix result = new Matrix(columns,rows);
    for(int i=0;i<rows;i++){
      for(int j=0;j<columns;j++){
        result.matrix[j][i]=matrix[i][j];
      }
    }
    return result;
  }
  
  Matrix singleColumnMatrixFromArray(float[] arr){
    Matrix result = new Matrix(arr.length,1);
    for(int i=0;i<arr.length;i++){
      result.matrix[i][0]=arr[i];
    }
    return result;
  }
  
  float[] toArray(){
    float[] arr = new float[rows*columns];
    for(int i=0;i<rows;i++){
      for(int j=0;j<columns;j++){
        arr[j+i*columns]=matrix[i][j];
      }
    }
    return arr;
  }
  
  void fromArray(float[] arr){
    for(int i=0;i<rows;i++){
      for(int j=0;j<columns;j++){
        matrix[i][j]=arr[j+i*columns];
      }
    }
  }
  
  Matrix addBias(){
    Matrix result = new Matrix(rows+1,1);
    for(int i=0;i<rows;i++){
      result.matrix[i][0]=matrix[i][0];
    }
    return result;
  }
  
  float sigmoid(float a){
    return 1/(1+pow((float)Math.E,-a));
  }
  
  float derivedSigmoid(float a){
    return a*(1-a);
  }
  
  Matrix activate(){
    Matrix result= new Matrix(rows,columns);
    for(int i=0;i<rows;i++){
      for(int j=0;j<columns;j++){
        result.matrix[i][j]=sigmoid(matrix[i][j]);
      }
    }
    return result;
  }
  
  Matrix deActivate(){
    Matrix result = new Matrix(rows,columns);
    for(int i=0;i<rows;i++){
      for(int j=0;j<columns;j++){
        result.matrix[i][j]=derivedSigmoid(matrix[i][j]);
      }
    }
    return result;
  }
  
  void mutate(float mutationRate){
    for(int i=0;i<rows;i++){
      for(int j=0;j<columns;j++){
        float rand=random();
        if(rand<mutationRate){
          matrix[i][j]+=randomGaussian()/5;
          if(matrix[i][j]>1) matrix[i][j]=1;
          if(matrix[i][j]<-1) matrix[i][j]=-1;
        }
      }
    }
  }
  
  Matrix crossOver(Matrix partner){
    Matrix child = new Matrix(rows,columns);
    int randR=floor(random(rows));
    int randC=floor(random(columns));
    for(int i=0;i<rows;i++){
      for(int j=0;j<columns;j++){
        if((i<randR) || (i==randR && j<=randC)){
          child.matrix[i][j] = matrix[i][j];
        }else{
          child.matrix[i][j]=partner.matrix[i][j];
        }
      }
    }
    return child;
  }
  
  Matrix clone() {
    Matrix clone = new  Matrix(rows, columns);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<columns; j++) {
        clone.matrix[i][j] = matrix[i][j];
      }
    }
    return clone;
  }
  
}
