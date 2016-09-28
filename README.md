### Instruction

#### Step 1:

```
git clone git@github.com:buinhansinh/hadoop-test-framework.git
```

#### Step 2:

```
cd test_framework
```


#### Step 3: (Run local integration test for example)

```
./local_test.sh mapreduce/mapper.py mapreduce/reducer.py tests
```

#### Step 4: (Run tests for example on local hadoop cluster)

```
./hadoop_test.sh mapreduce/mapper.py mapreduce/reducer.py tests ../
```

### Explaination
The **tests** folder above contains the input for mapper and the expected output after reduction. In the test folder , you should have the files obeying the following format.
- *.input: represent the test case (test1.input)
- *.output: represent the expected output for the same test (test1.output)
