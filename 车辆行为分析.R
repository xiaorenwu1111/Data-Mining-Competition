setwd("C://Users//liyufang//Desktop//泰迪杯-车辆行为分析//15193005zo67//附件1-示例数据-100辆车")
#第一部分 车辆数据与经纬度注释数据的预处理和对应
AB00006=read.csv("AB00006.csv",header=T,sep=",")
#1.将经纬度信息转换为只保留两位小数的数据
AB00006$lng=round(AB00006$lng,3)
AB00006$lat=round(AB00006$lat,3)
#AB00006$location_time=strsplit(as.character(AB00006$location_time)," ")
#转换时间格式
library(stringr)
AB00006$location_time=str_split_fixed(as.character(AB00006$location_time)," ", 2)
write.csv(AB00006,"C://Users//liyufang//Desktop//泰迪杯-车辆行为分析//AB00006.csv")
AB00006_dealt=read.csv("C://Users//liyufang//Desktop//泰迪杯-车辆行为分析//AB00006.csv",header=T,sep=",")
AB00006_dealt=AB00006_dealt[,-1]
AB00006_dealt$location_time.1=as.Date(AB00006_dealt$location_time.1)




#第二部分 天气信息和经纬度注释信息数据预处理和数据对应 
#读入经纬度的注释信息
weather=read.csv("C://Users//liyufang//Desktop//泰迪杯-车辆行为分析//13000123sgik//第七届泰迪杯赛题C题-全部数据//附件2-气象数据.csv",header=T,sep=",")
#生成地区的数据 
weather$deatail_location=NA
weather$deatail_location=paste(weather$province,weather$prefecture_city,weather$county,sep="")
#head(weather)
#转换时间格式，将时间格式转换为“年-月-日”格式
weather$record_date=as.character(as.Date(weather$record_dat,"%d/%m/%Y"))
#weather_data=weather[match(weather_data$prefecture_city,anno$prefecture_city),]
location=read.csv("F://泰迪杯数学建模大赛//第七届泰迪杯赛题C题-全部数据//经纬度-地理位置对应表.csv",header=T,sep=",")
library(dplyr)
weather_location=left_join(weather,location,by="deatail_location")
#转化经纬度坐标的小数位数
weather_location$lng=round(weather_location$lng,3)
weather_location$lat=round(weather_location$lat,3)




#第三部分 将天气信息和车辆信息通过deatail_location字段和date字段进行关联
colnames(AB00006_dealt)[11]<-"date"
colnames(weather_location)[11]<-"date"
#write.csv(Vehicle_data,"C://Users//liyufang//Desktop//泰迪杯-车辆行为分析//Vehicle_data.csv")
#write.csv(weather_data,"C://Users//liyufang//Desktop//泰迪杯-车辆行为分析//weather_data.csv")
final_data=merge(AB00006_dealt,weather_location,by=c("lng",'lat',"date"))
write.csv(final_data,"C://Users//liyufang//Desktop//泰迪杯-车辆行为分析//AB00006_final_data.csv")

#第四部分 建模与统计分析
files='F://泰迪杯数学建模大赛//第七届泰迪杯赛题C题-全部数据//附件1-全部数据-450辆车'
dir_name=dir(files,recursive=T)
result=data.frame(车牌号=substr(dir_name,1,7),大暴雨=0,暴雨=0,大雨=0,中雨=0,小雨=0,雾=0,雪=0,浮尘=0,强风=0,大风=0,暴风=0,台风=0,评分=0)
write.csv(result,"F://泰迪杯数学建模大赛//第七届泰迪杯赛题C题-全部数据//3_result.csv")

n_big_storm_rain=function(conditions){
  n=length(grep("*大暴雨*",conditions,value=T))
  return(n)
}
n_storm_rain=function(conditions){
  n=length(grep("*暴雨*",conditions,value=T))
  return(n)
}
n_big_rain=function(conditions){
  n=lenght(grep("*大雨*",conditions,value=T))
  return(n)
}
n_middle_rain=function(conditions){
  n=length(grep("*中雨*",conditions,value=T))
  return(n)
}
n_small_rain=function(conditions){
  n=length(grep("*小雨*",conditions,value=T))
  return(n)
}
n_fog=function(conditions){
  n=length(grep("*雾*",conditions,value=T))
  return(n)
}

n_snow=function(conditions){
  n=length(grep("*雪*",conditions,value=T))
  return(n)
}
n_fly_ash=function(conditions){
  n=length(grep("*浮尘*",conditions,value=T))
  return(n)
}
y=strong_breeze(weather_location$wind_power)
x=grep("*[1-9]*",c("qa1a3d","001a7"))
weather_condition=function(condition){
   for(i in length(condition)){
     n_big_storm_rain=length(grep("*大暴雨*",conditions,value=T))
      n_storm_rain=length(grep("*暴雨*",conditions,value=T))
      n_big_rain=lenght(grep("*大雨*",conditions,value=T))
      n_middle_rain=lenght(grep("*中雨*",conditions,value=T))
      n_small_rain=lenght(grep("*小雨*",conditions,value=T))
      n_fog=length(grep("*雾*",conditions,value=T))
      n_snow=length(grep("*雪*",conditions,value=T))
      n_fly_ash=length(grep("*浮尘*",conditions,value=T))
   }
   return(n_big_storm_rain)
 }

