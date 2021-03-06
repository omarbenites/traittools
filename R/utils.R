#' Get all the trait variables of fieldbooks, excluding all the fieldbook factors
#' @param date_value A date to be fixed when you import dates from Excel
#' @description When you import dates from Excel, it is quite common that some error or format issues happen. So,
#' this function changes from yyyy/mm/dd to ddd/mm/yyyy.
#' @author omar benites
#' @return A fixed date
#' @examples
#' \dontrun{
#' # The data
#' fix_excel_date(date_value="2013-05-22")
#' } 
#' @export
#'
mutate_excel_date <- function(date_value){
  
  #date_value initilly has his format: dd-mm-yyyy in the excel file and internally R transforms to 
  date_value <- gsub("/","-",date_value)
  std  <-  as.integer(strsplit(date_value,"-")[[1]])
  if(nchar(std[1])==4){ #if the first split is the year (four characters)
    #format: yyyy-dd-mm 
    date_value <- paste(std[1],std[3],std[2], sep = "-")
    #date_value <- paste(std[1],std[2],std[3],sep = "-") #for chiara's book (kunningLB042015)
  }
  if(nchar(std[1])==2){ #If std only have two numbers (for example 15-10-2015)
    #format: yyyy-dd-mm
    date_value <- paste(std[3],std[2],std[1],sep = "-")
   }# else {
   if(nchar(std[1])==1){ #If std only have one number in the date (for example 8-8-2015)
    #date_value <- paste(std[3],std[2],std[1],sep = "-")
    date_value <- paste(std[3],std[2],std[1],sep = "-")
  }
  
    date_value
}

#' Get all the trait variables of fieldbooks, excluding all the fieldbook factors
#' @param fieldbook A data.frame which contain fieldbook data
#' @param dsource source of the data \code{1}: Hidap,  \code{2}: FieldbookApp. 
#' @description #filter values which will not be evaluated becasuse dont have scale
#' EDATE and DATESP are dates so they need to be removed from analyisis and rendering tables
#' This variable exclude all the column header that belongs to.
#' @author omar benites
#' @return All the trait variables
#' @export
#' 
get_trait_fb <- function(fieldbook, dsource = 1){
   
  
  if(dsource == 1){ 
  
    factors <-c("PLOT","INSTN","REP","BLOCK","FACTOR", "ORDER","IDENTIFIED_CRITERIA",
                 "EDATE","DATESP", "SELECT", "OBS", "COLBR", "PHASE", "STYPE","BLOCK_ROW", 
                 "BLOCK_COL","CBLOCK","SUBPLOT","SUBSAMPLE",
                 "ROW", "COLUMN",
                 "SET", "MALE", "FEMALE",
                 "LINE", "TESTER")
    trait_names <- names(fieldbook)
    trait_names <- names(fieldbook)[!is.element(names(fieldbook),factors)]
    
  }
  if( dsource == 2){
       #factors <-c("abbr_user",	"plot_number", "plot_id","rep",	"accesion_name"	,"timestamp",	"person",	"location",	"number")
       factors <- c("plot_name", "plot_id", "abbr_user", "block_number", "plot_number", "rep_number" , "row_number", "col_number",
                  "accession_name",  "is_a_control", "synosyms", "trial_name", "location_name", "year", "pedigree",
                  "tier", "seedlot_name", "seed_transaction_operator", "num_seed_per_plot", "range_number", "plot_geo_json",
                  "timestamp",	"person"	,"location",	"number")
       trait_names <- names(fieldbook)
       trait_names <- names(fieldbook)[!is.element(names(fieldbook),factors)]
       
       #trait_names <- gsub("[A-z0-9].*-","", trait_names)
  }
   
   
   # trait_names <- names(fieldbook)
   # trait_names <- names(fieldbook)[!is.element(names(fieldbook),factors)]
   trait_names <- stringr::str_trim(trait_names, side = "both")
   trait_names <- trait_names[trait_names!=""]
   trait_names
 }
 
 #' Read fieldbooks in reactive enviorment (Shiny)
 #' @param file_id The id of the shinyInput for an fieldbook excel (input$shinyInput_id).
 #' @param sheet The name of sheet which contains fieldbook data
 #' @author omar benites
 #' @return A data.frame contains the fieldbook data
 #' @export
 #'  
 
reactive_excel_fb <- function(file_id,sheet){
   #fb_file <- input$hot_file
   file.copy(file_id$datapath, paste(file_id$datapath, ".xlsx", sep=""))
   fieldbook <- readxl::read_excel(paste(file_id$datapath, ".xlsx", sep=""), sheet = sheet)
   fieldbook
 } 

#' Read metadata in reactive enviorment (Shiny)
#' @param file_id The shinyInput's ID of the excel file (input$shinyInput_id).
#' @param sheet The name of sheet which contains meta data
#' @author omar benites
#' @return A data.frame contains the meta data
#' @export
#'  
reactive_excel_metadata <- function(file_id,sheet){
  #fb_file <- input$hot_file
  file.copy(file_id$datapath, paste(file_id$datapath, ".xlsx", sep=""))
  fieldbook <- openxlsx::read.xlsx(xlsxFile= paste(file_id$datapath, ".xlsx", sep=""),
                                   sheet = sheet,detectDates = TRUE)
  fieldbook
}

#' Get fieldbook parameters into Excel Files
#' @description This function gets parameters or values from fieldbook excel file. Do an excel scrapping.
#' @param param_data Parameter sheet data
## @param file The file name
## @param sheet The sheet name
#' @param parameter The label of the factor we want to extract. Ex. "Experimental design", "Plot_Size"
#' @export
#' 
get_fb_param <- function(param_data,parameter){
   #fb_param <- readxl::read_excel(path = file, sheet = sheet)
   #fb_param<- as.data.frame(fb_param)
   
   fb_param <- as.data.frame(param_data)
   fb_param$Factor <- stringr::str_trim(fb_param$Factor,"both")
   fb_param <- fb_param[fb_param$Factor==parameter,2]
   #fb_param <- stringr::str_trim(fb_param,"both")
   fb_param
 }
 

#' Get data from excel files
#' @description This function gets all the data from excel files. 
#' @param file The file name
#' @param sheet The sheet name
#' @export
#' 
get_sheet_data <- function(file,sheet){
  table_param <- readxl::read_excel(path = file, sheet = sheet)
  table_param <- as.data.frame(table_param)
  table_param
  #value_param <- as.numeric(table_param[stringr::str_detect(table_param[,row_param],value_param),col_param])
  #value_param
  #lapply(x <- 1:ncol(parameter), function(x) parameter[,x]<-as.character(parameter[,x]))
  #for(i in 1:ncol(params)) params[,i]<-as.character(params[,i])
  #parameter[parameter$Factor==parameter,2]
  #plot_size  <-  as.numeric(inst[stringr::str_detect(inst$Factor,"Plot size"),"Value"])
}

#' Get the trait dictionary acordding to crop and trial.
#' @description Function to obtain the trait dictionary (used in Crop Ontology) according to
#' crop and trial (yield, drought, late blight, Etc.).
#' @param crop The name of the crop
#' @param trial The name of the trial
#' @param dsource source of the data \code{1}: Hidap,  \code{2}: FieldbookApp. 
#' @export
#'
get_crop_ontology <- function(crop,trial=NA, dsource = 1){

  trial <- tolower(trial)
  dsource <- dsource
  
  if(crop == "potato"){
    #if(trial=="yield") trait_dict <- potato_yield
    ##if(trial=="Mother&Baby") trait_dict <- potato_motherbaby
    #if(trial=="late blight") trait_dict <- potato_lb
    ##if(trial=="drought tolerance") trait_dict <- potato_drought #In DataCollector
    #if(trial=="drought") trait_dict <- potato_drought  #in HiDAp
    ##if(trial=="dormancy") trait_dict <- potato_dormancy
    #if(trial=="bulking") trait_dict <- potato_bulking
    #trait_dict <- td_potato
    #trait_dict <- fbdesign::table_module_potato
    trait_dict <- table_module_potato
  }

  if(crop == "sweetpotato"){ 
    #if(trial=="yield") trait_dict <- sweetpotato_yield
    #trait_dict <- td_sweetpotato
    #trait_dict <- fbdesign::table_module_sweetpotato
    if(dsource==1) { trait_dict <- table_module_sweetpotato }
    if(dsource==2)  { trait_dict <- table_module_sweetpotato_sbase}
  }

  trait_dict
}

#' Post the fieldbook data into excel files
#' @description This function gets all the data from excel files. 
#' @param file The file name
#' @param sheet The sheet name
#' @param fieldbook The fieldbook data
#' @export
#' 
post_sheet_data <- function(file,sheet,fieldbook){
  
      wb <- openxlsx::loadWorkbook(file = file)
      sheets <- readxl::excel_sheets(path = file)
      if(sheet %in% sheets){    
        openxlsx::removeWorksheet(wb = wb, sheet = sheet)
      }
      openxlsx::addWorksheet(wb = wb,sheetName = sheet, gridLines = TRUE)
      openxlsx::writeDataTable(wb = wb,sheet = sheet, x = fieldbook, colNames = TRUE, withFilter = FALSE)
      openxlsx::saveWorkbook(wb = wb, file = sheet, overwrite = TRUE)
}
#Not run #traittools::post_sheet_data(file = hot_file,sheet = "Fieldbook",fieldbook = DF)

#' lapply transformation of dates using mutate_excel_date
#' @description Transformation of dates using mgt
#' @param mgt crop management sheet or table
#' @export
#' 
transform_dates <- function(mgt){
   mgt$Date <- unlist(lapply(mgt$Date,function(x){mutate_excel_date(x)}))
   mgt
}

#' Get Relative Dates for Area Under the Curve(AUDPC)
#' @description mgt function calculate relative days for Late Blight Resistance. 
#' @param mgt The crop managemente data
#' @export
#' 
get.rel.days <- function(mgt){
  
  mgt <- mgt
  
  start.date = mgt[mgt$Intervention_type=="Planting","Date"]
  std = as.integer(strsplit(start.date,"-")[[1]])
  std = as.integer(mdy.date(std[2],std[3],std[1]))
  
  lb = paste("Percentage of foliage affected by Late Blight",1:12)
  mgt$Date = as.character(mgt$Date)
  mgt$Intervention_type = as.character(mgt$Intervention_type)
  
  #print(mgt)
  
  
  ds = mgt[mgt$Intervention_type %in% lb,"Date"]
  di = integer(length(ds))
  for(i in 1:length(ds)){
    dx = as.integer(strsplit(ds[i],"-")[[1]])
    print(dx)
    if(length(dx)==3){
      print(date::mdy.date(dx[2],dx[3],dx[1])	)
      di[i] = date::mdy.date(dx[2],dx[3],dx[1])	
      print(di[i])
    } else {
      break
    }
  }
  #std = di[1]
  di=di-std
  #di[1] = di[1]+1
  #print(di)
  di #GTDM-43
  #print(mgt)
  #print(di)
}

#' Get the scale for late blight test to compare with other genotypes
#' @description Function calculate relative days for Late Blight Resistance. 
#' @param mtl The material list data
#' @export
#' 
get.lb.control <-function(mtl){
  #mtl$Scale.AUDPC.control = as.integer(mtl$Scale.AUDPC.control) #in DataCollector
  mtl$Scale_audpc = as.integer(mtl$Scale_audpc) #in HiDAP
  #mtl$Institutional.number= as.character(mtl$Institutional.number) #in DataCollector
  mtl$Institutional_number= as.character(mtl$Accession_Number) #in HiDAP
  #mtl[!is.na(mtl$Scale.AUDPC.control),c("Institutional.number","Scale.AUDPC.control")]	#in DataCollector
  mtl[!is.na(mtl$Scale_audpc),c("Institutional_number","Scale_audpc")] #in HiDAP
}

#' Scale for Area Under the Curve (Scale AUDPC)
#' @description Function calculate relative days for Late Blight Resistance. 
#' @param instn character value "INSTN" (The institucional number header)
#' @param audpc the audpc value
#' @param reps The number of repetitions
#' @param lb.ctrl The control genotype scale value of resistance for late blight trial.
#' @export

saudpc <-function(instn, audpc, reps, lb.ctrl){
  audpc=as.numeric(as.character(audpc))
  #sc.ctrl = as.integer(lb.ctrl["Scale.AUDPC.control"]) #in DataCollector
  sc.ctrl = as.integer(lb.ctrl["Scale_audpc"])
  saudpc = numeric(length(audpc))
  reps = as.integer(as.character(reps))
  rs=sort(unique(reps))
  
  ref.audpc=NULL
  for(i in 1:length(rs)){
    f = which(reps==rs[i])
    #print(f)
    a = audpc[f]
    #print(a)
    n = instn[f]
    #print(n)
    #p = which(n==lb.ctrl["Institutional.number"][[1]]) #in DataCollector
    p = which(n==lb.ctrl["Institutional_number"][[1]]) #in HiDAP
    if(length(p)==0){
      au.ctrl = ref.audpc
      #print(i)
    } else {
      #print(i)
      au.ctrl = a[p]	
      ref.audpc = au.ctrl
    }
    
    #print(au.ctrl)
    a=a/au.ctrl * sc.ctrl
    #print(sc.ctrl)
    #print(a)
    saudpc[f]=a
  }
  
  round(saudpc, 1)
}

#' Get Relative Value for Area Under the Curve(AUDPC)
#' @description Function calculate relative days for Late Blight Resistance. 
#' @param eval The trait evaluation
#' @param dates The dates of evaluation
#' @param type The type of trial
#' @export

xaudpc <- function(eval, dates, type){
  pts = length(dates)
  audpc(eval[,1:pts], dates, type)
}

