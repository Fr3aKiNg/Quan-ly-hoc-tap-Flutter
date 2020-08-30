DateTime dateTimeConverter (String myDate){
  String month;

  String hour = myDate.substring(17, 25); //Get the hour section [22:00:00]

  String day = myDate.substring(5, 7); //Get the day section [28]

  if(myDate.substring(8, 11) == 'Jan'){ //Converting the month Section
    month = '01';
  } else if(myDate.substring(8, 11) == 'Feb'){
    month = '02';
  } else if(myDate.substring(8, 11) == 'Mar'){
    month = '03';
  } else if(myDate.substring(8, 11) == 'Apr'){
    month = '04';
  } else if(myDate.substring(8, 11) == 'May'){
    month = '05';
  } else if(myDate.substring(8, 11) == 'Jun'){
    month = '06';
  } else if(myDate.substring(8, 11) == 'Jul'){
    month = '07';
  } else if(myDate.substring(8, 11) == 'Aug'){
    month = '08';
  } else if(myDate.substring(8, 11) == 'Sep'){
    month = '09';
  } else if(myDate.substring(8, 11) == 'Oct'){
    month = '10';
  } else if(myDate.substring(8, 11) == 'Nov'){
    month = '11';
  } else if(myDate.substring(8, 11) == 'Dec'){
    month = '12';
  }

  String year = myDate.substring(12, 16); //Get the year section

  String date = year + '-' + month + '-' + day + ' ' + hour; //Combine them
 // print('Before Parsing: $date');

  DateTime parsedDate = DateTime.parse(date); //parsed it.
  //print('After Parsing: $parsedDate');

  return parsedDate;
}


getDate(str)
{
  DateTime tmpDate = dateTimeConverter(str);
  String date = tmpDate.day.toString()+'/'+tmpDate.month.toString()+'/'+tmpDate.year.toString();
  return date;
}

getTime(str)
{
  DateTime tmpDate = dateTimeConverter(str);
  String date = tmpDate.hour.toString()+':'+tmpDate.minute.toString()+':'+tmpDate.second.toString();
  return date;
}