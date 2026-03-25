
class Users {
  late String firstname;
  late String lastName;
  late String address;
  late String contactNumber;
  late String type;
  late String pic;
  late String description;
  late DateTime? birthday;
  late String gender;
  Users({
    this.firstname='',
    this.lastName='',
    this.address='',
    this.contactNumber='',
    this.type='',
    this.pic='',
    this.description='',
    this.gender='', this.birthday
  });

  Users.map(Map map){
    firstname = map['firstName']??'';
    lastName = map['lastName']??'';
    address = map['address']??'';
    contactNumber = map['contactNumber']??'';
    type = map['type']??'';
    pic = map['pic']??'';
    description = map['description']??'';
    gender = map['gender']??'';
    birthday =  DateTime.fromMillisecondsSinceEpoch(map['birthday'].millisecondsSinceEpoch);
  }
}

// Demo data for our cart


