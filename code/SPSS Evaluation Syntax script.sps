* Encoding: UTF-8.
*2-step cluster analysis of age, using  Schwarz’ Bayesian Criterion
  
  TWOSTEP CLUSTER 
  /CONTINUOUS VARIABLES=Age 
  /DISTANCE LIKELIHOOD 
  /NUMCLUSTERS AUTO 15 BIC 
  /HANDLENOISE 0 
  /MEMALLOCATE 64 
  /CRITERIA INITHRESHOLD(0) MXBRANCH(8) MXLEVEL(3) 
  /VIEWMODEL DISPLAY=YES.


*Generalized Linear Mixed Models, examining the main effect of spokesperson, age group and country, 
the 2-way interactions of spokesperson × country and spokesperson × age group, 
and the 3-way interaction of spokesperson × country × age group on message sharing, controlling for 
demographic and attitudinal measures.

GENLINMIXED
  /DATA_STRUCTURE SUBJECTS=Number REPEATED_MEASURES=Country1_6 COVARIANCE_TYPE=DIAGONAL
  /FIELDS TARGET=Share.Msg TRIALS=NONE OFFSET=NONE
  /TARGET_OPTIONS DISTRIBUTION=NORMAL LINK=IDENTITY
  /FIXED  EFFECTS=Speaker1_5 Country1_6 Age_Group Speaker1_5*Country1_6 Speaker1_5*Age_Group Speaker1_5*Country1_6*Age_Group Gender Employment City.size Education Household‎.size_RMV Concern.Situation Concern.Others Others.SD Movement Infection.percent
    Subj.Health Satisfaction.Gov PHealth.vs.Econ Religiosity Support.SD Current.SD Future.SD Measures.SD USE_INTERCEPT=TRUE
  /BUILD_OPTIONS TARGET_CATEGORY_ORDER=ASCENDING INPUTS_CATEGORY_ORDER=ASCENDING MAX_ITERATIONS=100 CONFIDENCE_LEVEL=95 DF_METHOD=RESIDUAL COVB=ROBUST PCONVERGE=0.000001(ABSOLUTE) SCORING=0 SINGULAR=0.000000000001
  /EMMEANS TABLES=Speaker1_5 COMPARE=Speaker1_5 CONTRAST=PAIRWISE
   /EMMEANS TABLES=Country1_6 COMPARE=Country1_6 CONTRAST=PAIRWISE
   /EMMEANS TABLES=Age_Group COMPARE=Age_Group CONTRAST=PAIRWISE
   /EMMEANS TABLES=Speaker1_5*Country1_6 COMPARE=Speaker1_5 CONTRAST=PAIRWISE
   /EMMEANS TABLES=Speaker1_5*Age_Group COMPARE=Speaker1_5 CONTRAST=PAIRWISE
   /EMMEANS TABLES=Gender COMPARE=Gender CONTRAST=SIMPLE
   /EMMEANS TABLES=Employment CONTRAST=NONE
   /EMMEANS TABLES=City.size CONTRAST=NONE
   /EMMEANS TABLES=Education CONTRAST=NONE
   /EMMEANS TABLES=Concern.Situation CONTRAST=NONE
   /EMMEANS TABLES=Concern.Others CONTRAST=NONE
   /EMMEANS TABLES=Others.SD CONTRAST=NONE
   /EMMEANS TABLES=Movement CONTRAST=NONE
   /EMMEANS TABLES=Infection.percent CONTRAST=NONE
   /EMMEANS TABLES=Subj.Health CONTRAST=NONE
   /EMMEANS TABLES=Satisfaction.Gov CONTRAST=NONE
   /EMMEANS TABLES=PHealth.vs.Econ CONTRAST=NONE
   /EMMEANS TABLES=Religiosity CONTRAST=NONE
   /EMMEANS TABLES=Speaker1_5*Country1_6*Age_Group COMPARE=Speaker1_5 CONTRAST=PAIRWISE
  /EMMEANS_OPTIONS SCALE=ORIGINAL PADJUST=SEQBONFERRONI.



* Model examining the effect of likeability on message sharing. 
*Step 1. Generalized Linear Mixed Models to remove the shared variance of age, gender, and all 
demographic and attitudinal variables with message sharing from the data excluding the no-speaker
condition. This is used as a reference point to the effect of the spokesperson on message sharing. 

GENLINMIXED 
  /DATA_STRUCTURE SUBJECTS=Number 
  /FIELDS TARGET=Share.Msg TRIALS=NONE OFFSET=NONE 
  /TARGET_OPTIONS DISTRIBUTION=NORMAL LINK=IDENTITY 
  /FIXED  EFFECTS=Age_Group Gender Employment City.size Household‎.size_RMV Education Concern.Situation Concern.Others Others.SD Movement Infection.percent Subj.Health Satisfaction.Gov PHealth.vs.Econ Religiosity Support.SD Current.SD Future.SD 
    Measures.SD Country1_6 USE_INTERCEPT=TRUE 
  /BUILD_OPTIONS TARGET_CATEGORY_ORDER=ASCENDING INPUTS_CATEGORY_ORDER=ASCENDING MAX_ITERATIONS=100 CONFIDENCE_LEVEL=95 DF_METHOD=RESIDUAL COVB=ROBUST PCONVERGE=0.000001(ABSOLUTE) SCORING=0 SINGULAR=0.000000000001 
  /EMMEANS TABLES=Age_Group CONTRAST=NONE 
   /EMMEANS TABLES=Gender CONTRAST=NONE 
   /EMMEANS TABLES=Employment CONTRAST=NONE 
   /EMMEANS TABLES=City.size CONTRAST=NONE 
   /EMMEANS TABLES=Subj.Health CONTRAST=NONE 
   /EMMEANS TABLES=Satisfaction.Gov CONTRAST=NONE 
   /EMMEANS TABLES=PHealth.vs.Econ CONTRAST=NONE 
   /EMMEANS TABLES=Religiosity CONTRAST=NONE 
  /EMMEANS_OPTIONS SCALE=ORIGINAL PADJUST=LSD.


* Step 2. Generalized Linear Mixed Models to remove the shared variance of age, gender, and all 
demographic and attitudinal variables with message sharing from the no-speaker condition only.

GENLINMIXED 
  /DATA_STRUCTURE SUBJECTS=Number 
  /FIELDS TARGET=Share.Msg TRIALS=NONE OFFSET=NONE 
  /TARGET_OPTIONS DISTRIBUTION=NORMAL LINK=IDENTITY 
  /FIXED  EFFECTS=Age_Group Gender Employment City.size Household‎.size_RMV Education Concern.Situation Concern.Others Others.SD Movement Infection.percent Subj.Health Satisfaction.Gov PHealth.vs.Econ Religiosity Support.SD Current.SD Future.SD 
    Measures.SD Country1_6 USE_INTERCEPT=TRUE 
  /BUILD_OPTIONS TARGET_CATEGORY_ORDER=ASCENDING INPUTS_CATEGORY_ORDER=ASCENDING MAX_ITERATIONS=100 CONFIDENCE_LEVEL=95 DF_METHOD=RESIDUAL COVB=ROBUST PCONVERGE=0.000001(ABSOLUTE) SCORING=0 SINGULAR=0.000000000001 
  /EMMEANS TABLES=Age_Group CONTRAST=NONE 
   /EMMEANS TABLES=Gender CONTRAST=NONE 
   /EMMEANS TABLES=Employment CONTRAST=NONE 
   /EMMEANS TABLES=City.size CONTRAST=NONE 
   /EMMEANS TABLES=Subj.Health CONTRAST=NONE 
   /EMMEANS TABLES=Satisfaction.Gov CONTRAST=NONE 
   /EMMEANS TABLES=PHealth.vs.Econ CONTRAST=NONE 
   /EMMEANS TABLES=Religiosity CONTRAST=NONE 
  /EMMEANS_OPTIONS SCALE=ORIGINAL PADJUST=LSD.

*Step 3. Generalized Linear Mixed Models examining the main effect of spokesperson, country and 
likeability, the 2-way interactions of spokesperson × country, country × likeability, spokesperson ×
likeability, and the 3-way interaction of spokesperson × country × likeability, on the stadardized 
Pearson residual obtained in Step 2.

GENLINMIXED
  /DATA_STRUCTURE SUBJECTS=Number REPEATED_MEASURES=Country1_6 COVARIANCE_TYPE=DIAGONAL
  /FIELDS TARGET=PResidual TRIALS=NONE OFFSET=NONE
  /TARGET_OPTIONS DISTRIBUTION=NORMAL LINK=IDENTITY
  /FIXED  EFFECTS=Speaker1_5 Country1_6 Speaker.Like Speaker1_5*Country1_6 Speaker1_5*Speaker.Like Speaker.Like*Country1_6 Speaker1_5*Speaker.Like*Country1_6 USE_INTERCEPT=TRUE
  /BUILD_OPTIONS TARGET_CATEGORY_ORDER=ASCENDING INPUTS_CATEGORY_ORDER=ASCENDING MAX_ITERATIONS=100 CONFIDENCE_LEVEL=95 DF_METHOD=RESIDUAL COVB=ROBUST PCONVERGE=0.000001(ABSOLUTE) SCORING=0 SINGULAR=0.000000000001
  /EMMEANS TABLES=Speaker1_5 CONTRAST=NONE
   /EMMEANS TABLES=Country1_6 CONTRAST=NONE
   /EMMEANS TABLES=Speaker.Like COMPARE=Speaker.Like CONTRAST=PAIRWISE
   /EMMEANS TABLES=Speaker1_5*Country1_6 CONTRAST=NONE
   /EMMEANS TABLES=Speaker1_5*Speaker.Like COMPARE=Speaker1_5 CONTRAST=PAIRWISE
   /EMMEANS TABLES=Speaker.Like*Country1_6 COMPARE=Speaker.Like CONTRAST=PAIRWISE
   /EMMEANS TABLES=Speaker1_5*Speaker.Like*Country1_6 COMPARE=Speaker1_5 CONTRAST=PAIRWISE
  /EMMEANS_OPTIONS SCALE=ORIGINAL PADJUST=SEQBONFERRONI.
