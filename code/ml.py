
#libaries na ginamit natin 
from flask import Flask, request, jsonify #para sa pagsetup ng api request
from sklearn.tree import DecisionTreeClassifier #para sa pag train at prediction ng AI, ito AI na gamit natin
from agora_token_builder import RtcTokenBuilder #para sa pag generate ng token sa Agora
import datetime #pag convert ng date and time natin from millisecond and vice versa
import joblib #pang load and save natin ng AI train model sa local
import pyrebase #pagconnect natin sa firebase
import pytz #pag convert ng UTC to GMT+8

#config para makaconnect tayo sa firebase, makukuha ninyo ito sa console sa setup
firebaseConfig = {
  "apiKey": "AIzaSyDa7cOSfulYwus9qWyLsh2x4VFqzlIxURM",
  "authDomain": "asthma-care.firebaseapp.com",
  "databaseURL": "https://asthma-care-default-rtdb.asia-southeast1.firebasedatabase.app",
  "projectId": "asthma-care",
  "storageBucket": "asthma-care.appspot.com",
  "messagingSenderId": "73254897805",
  "appId": "1:73254897805:web:a03b8f29fd62e28fdb3ac4",
  "measurementId": "G-NX6RNH2VM3"
};

#pag initialize natin sa firebase para magconnect
firebase = pyrebase.initialize_app(firebaseConfig)
#declaration ng pagconnect sa realtime database
db = firebase.database()

#initialize flask
app = Flask(__name__)

# Define your Agora App ID and App Certificate (from your Agora account)
app_id = "9850b464cbf643429a7166b599180ec6"
app_certificate = "d90ed144ce92496a973c40e27d7d4523"

#Rest Api Endpoint para sa pagchechech ng prediction ni AI
@app.route('/predict', methods=['POST'])
def predict():
    try:
        uid=request.json['uid'] #kunin muna sa request kung ano device uid ang pinasa
        data = db.child("sync").child(uid).get() #check natin kung sync yung model natin sa data sa firebase kung hindi sync kunin yung mga data ulit sa firebase tas gawa ng bagong model
        if data.val() is not None: #kung sync naman kunin natin yung model sa local iloload natin tas yun ang gagamitin
            value = data.val()
            print("Value:", value)
            if(value==True):
                try:
                    model = joblib.load(uid+'.pkl')
                except Exception as e:
                    print(e)
                    return jsonify({})
            else:
                data=db.child("ai").child(uid).get()
                if data.val() is not None:
                    value = data.val()
                    values_list = list(value.values())
                    myData=[]
                    myResult=[]
                    for d in values_list:
                        myData.append([int(d['ts'].split(':')[0]),int(d['ts'].split(':')[1]),d['b'],d['sp']])
                        myResult.append(d['s'])
                        
                    model = DecisionTreeClassifier()
                    model.fit(myData, myResult)
                    joblib.dump(model, uid+'.pkl')
                    db.child("sync").child(uid).set(True)
                else:
                    return jsonify({})

            
        else:
            return jsonify({})
        #once meron na tayo mode, kukunin pa natin yung siya pag galing sa request, yung data consisting of time, BPM , SPO2
        data = request.json['data']

        #yung time kasi galing sa firebase database, bali naka timestamp siya in seconds, kaya icoconvert pa natin siya UTC format
        datetime_obj = datetime.datetime.utcfromtimestamp(data[0] / 1000.0)
        gmt_plus_eight_datetime = datetime_obj.replace(tzinfo=pytz.utc).astimezone(pytz.timezone('Asia/Singapore')) #tas yung UTC format coconvert to GMT+8 kasi yun naman ang naiinput ni doctor
        #makukuha na natin yung hour at minite
        hour = gmt_plus_eight_datetime.hour
        minute = gmt_plus_eight_datetime.minute
        print(hour)
        print(minute)

        #iformat kung sa tamang pagbabasa ng model
        data = [float(x) for x in [hour, minute, data[1],data[2]]]
        prediction = model.predict([data])[0]

        return jsonify({"prediction": prediction}) #yung prediction ay yung ang irereturn na result

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/token', methods=['POST']) #ito yung pag gegenerate natin ng token for agora, pinapasa natin yung user_id, channelName
def generate_token():
    try:
        data = request.json
        user_id = data.get('user_id')
        channelName = data.get('channelName')
        role = data.get('role', 'PUBLISHER')

        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        if role not in ['PUBLISHER', 'SUBSCRIBER']:
            return jsonify({"error": "Invalid role"}), 400

        expiration_minutes = 60
        current_datetime = datetime.datetime.now()
        expiration_datetime = current_datetime + datetime.timedelta(minutes=expiration_minutes)
        expiration_timestamp = int((expiration_datetime - datetime.datetime(1970, 1, 1)).total_seconds())
        print("Start")
        token = RtcTokenBuilder.buildTokenWithUid(app_id, app_certificate, channelName, user_id,1, expiration_timestamp, )

        print("End")

        return jsonify({"token": token})

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True)
