
class Users {
  late String firstname;
  late String lastName;
  late String address;
  late String contactNumber;
  late String pic;
  late DateTime? birthday;
  late String gender;
  late String device;

  Users({this.firstname='',this.device='', this.lastName='', this.address='', this.contactNumber='',this.pic='', this.gender='', this.birthday});

  Users.map(Map map){
    firstname = map['firstName']??'';
    lastName = map['lastName']??'';
    address = map['address']??'';
    contactNumber = map['contactNumber']??'';
    pic = map['pic']??'';
    gender = map['gender']??'';
    device = map['device']??'';
    birthday =  DateTime.fromMillisecondsSinceEpoch(map['birthday'].millisecondsSinceEpoch);
  }
}

// Demo data for our cart


