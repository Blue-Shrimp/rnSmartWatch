import React, { useEffect, useState } from 'react'
import { Alert, SafeAreaView, Text, TextInput, TouchableOpacity, View } from 'react-native'
import { sendMessage, watchEvents } from 'react-native-watch-connectivity'

const App = () => {
  const [data, setData] = useState([
    { name: '수분', cnt: 0 },
    { name: '배변', cnt: 0 },
    { name: '수면', cnt: 0 },
    { name: '혈압', cnt: 0 },
    { name: '혈당', cnt: 0 },
  ]);

  const messageListener = () =>
    //여기로 메시지 들어옴
    watchEvents.on('message', msg => {
      console.log('msg : ', msg);
      setData(prevData => {
        // 이전 데이터 배열을 복제하여 새로운 배열을 생성합니다.
        const newData = [...prevData];

        // msg 객체의 각 키에 대해 반복하며 cnt 값을 업데이트합니다.
        for (const key in msg) {
          const index = newData.findIndex(item => item.name === key);
          if (index !== -1) {
            newData[index] = { ...newData[index], cnt: msg[key] };
          }
        }

        return newData;
      });
    })

  useEffect(() => {
    messageListener()
  }, [])

  const sendMessageToWatch = (datas = data) => {
    sendMessage(
      {
        objectFromApp: datas,
        waterCnt: datas.find(item => item.name === '수분').cnt,
        bowelCnt: datas.find(item => item.name === '배변').cnt,
        sleepCnt: datas.find(item => item.name === '수면').cnt,
        bpCnt: datas.find(item => item.name === '혈압').cnt,
        bsCnt: datas.find(item => item.name === '혈당').cnt,
      },
      reply => {
        console.log(reply)
      },
      error => {
        if (error) {
          // Alert.alert('메시지 전송 실패')
          console.log('error : ', error);
        }
      },
    )
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: 'white' }}>
      <View style={{ flex: 1, justifyContent: 'center' }}>
        {data.map((item, index) => {
          return (
            <View
              key={index}
              style={{
                borderWidth: 1,
                flexDirection: 'row',
                justifyContent: 'space-between',
                paddingHorizontal: 20,
                marginBottom: 20,
              }}
            >
              <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                <Text style={{ fontSize: 20, marginRight: 20 }}>{item.name}</Text>
                <Text style={{ fontSize: 20, marginRight: 10 }}>{item.cnt}</Text>
              </View>
              <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                <TouchableOpacity
                  onPress={() => {
                    let updatedData = [...data]
                    const index2 = updatedData.findIndex(v => v.name === item.name)
                    if (index2 !== -1) {
                      if (updatedData[index2].cnt > 0) {
                        updatedData[index2] = {
                          ...updatedData[index2],
                          cnt: updatedData[index2].cnt - 1,
                        }
                        setData(updatedData)
                      }
                    }
                    sendMessageToWatch(updatedData);
                  }}
                >
                  <Text style={{ fontSize: 20, marginRight: 20 }}>-</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  onPress={() => {
                    let updatedData = [...data];
                    const index2 = updatedData.findIndex(v => v.name === item.name);
                    if (index2 !== -1) {
                      updatedData[index2] = {
                        ...updatedData[index2],
                        cnt: updatedData[index2].cnt + 1,
                      };
                      setData(updatedData);
                    }
                    sendMessageToWatch(updatedData);
                  }}
                >
                  <Text style={{ fontSize: 20, marginRight: 10 }}>+</Text>
                </TouchableOpacity>
              </View>
            </View>
          )
        })}
      </View>
    </SafeAreaView>
  )
}

export default App
