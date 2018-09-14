class NeuralNetwork{
  
  int inputNodes;
  int hiddenNodes;
  int outputNodes;
  
  Matrix weightsHI;
  Matrix weightsHH;
  Matrix weightsOH;
  
  NeuralNetwork(int inputNodes,int hiddenNodes,int outputNodes){
    
    this.inputNodes=inputNodes;
    this.hiddenNodes=hiddenNodes;
    this.outputNodes=outputNodes;
    
    weightsHI= new Matrix(hiddenNodes,inputNodes+1); weightsHI.randomize();
    weightsHH = new Matrix(hiddenNodes,hiddenNodes+1); weightsHH.randomize();
    weightsOH = new Matrix(outputNodes,hiddenNodes+1); weightsOH.randomize();
    
  }
  
  void mutate(float mutationRate){
    weightsHI.mutate(mutationRate);
    weightsHH.mutate(mutationRate);
    weightsOH.mutate(mutationRate);
  }
  
  float[] output(float[] inputArray){
  
    //Convert the recieved input into matrix
    Matrix result = weightsHH.singleColumnMatrixFromArray(inputArray);
    
    //Add bias to matrix
    result=result.addBias();
    
   //Apply layer one weights to inputs
   result=weightsHI.dotProduct(result);
   
   //Pass through sigmoid function
   result=result.activate();
   
   //Add bias to result
   result=result.addBias();
   
   //Applying the same procedure for other two layers
   //Hidden Layer
   result=weightsHH.dotProduct(result);
   result=result.activate();
   result=result.addBias();
   
   //Output Layer
   result=weightsOH.dotProduct(result);
   result=result.activate();
   result=result.addBias();
   
   return result.toArray();
  }
  
  NeuralNetwork crossOver(NeuralNetwork partner){
    NeuralNetwork child = new NeuralNetwork(inputNodes,hiddenNodes,outputNodes);
    child.weightsHI = weightsHI.crossOver(partner.weightsHI);
    child.weightsHH = weightsHH.crossOver(partner.weightsHH);
    child.weightsOH = weightsOH.crossOver(partner.weightsOH);
    return child;
  }
  
  NeuralNetwork clone(){
    NeuralNetwork result = new NeuralNetwork(inputNodes,hiddenNodes,outputNodes);
    result.weightsHI=weightsHI.clone();
    result.weightsHH=weightsHH.clone();
    result.weightsOH=weightsOH.clone();
    return result;
  }
  
}
