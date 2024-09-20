

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class WriteScreen extends StatefulWidget{
    @override
  _NFCWriteScreenState createState()=>_NFCWriteScreenState();

}


class _NFCWriteScreenState extends State<WriteScreen>{

  final _key=GlobalKey<FormState>();
  String serialNumber = '';
  String atqa = '';
  String sak = '';
  String ats = '';

  String _nfcMessage = 'Tap an NFC card to read data';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Write data'),),
      body: Padding(
         padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Serial Number( format: aa:bb:cc:dd)'),
                  onSaved: (value) {
                    serialNumber = value!;
                  },
                  initialValue: '3C:77:36:11',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Serial Number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'ATQA (hex format: 0x0008)'),
                  onSaved: (value) {
                    atqa = value!;
                  },
                  initialValue: '0x0008',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter ATQA';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'SAK (hex format: 0x20)'),
                  onSaved: (value) {
                    sak = value!;
                  },
                  initialValue: '0x20',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter SAK';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'ATS (hex format: 0x81000300203002220100140D)'),
                  onSaved: (value) {
                    ats = value!;
                  },
                  initialValue: '0x81000300203002220100140D',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter ATS';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20,),
                MaterialButton(
                  onPressed: _startNFCWrite,
                  color: Colors.blue,
                  
                  child: Text('Write Data'),
                ),
                SizedBox(height: 20,),
                Text(_nfcMessage)

              ],
            ),
          )
      ),
    );
  }


  List<int> _parseSerial(String serial){
    debugPrint(serial);
    return serial.split(':').map(
      (part)=>int.parse(part,radix: 16)
    ).toList();

  }

  List<int> _parseHex(String hexString){
    hexString= hexString.replaceAll('0x', '');


    List<int> bytes=[];
    for(int i=0;i<hexString.length;i+=2){
      bytes.add(int.parse(hexString.substring(i,i+2),radix: 16));
    }
    debugPrint(bytes.toList().toString());
    return bytes;

  }


  void _startNFCWrite() async{
    if(_key.currentState!.validate()){
      _key.currentState!.save();

        // Parse inputs into byte arrays
        List<int> serialNumberBytes = _parseSerial(serialNumber);
        List<int> atqaBytes = _parseHex(atqa);
        List<int> sakBytes = _parseHex(sak);
        List<int> atsBytes = _parseHex(ats);

        // Combine all the parsed data into one list to write
        List<int> nfcData = [
          ...serialNumberBytes,
          ...atqaBytes,
          ...sakBytes,
          // ...atsBytes,
        ];

try {
        // Start polling NFC
        NFCTag tag = await FlutterNfcKit.poll();
        _nfcMessage = 'Tag detected!';
        setState(() {});

        // Convert the data to a hex string to write
        String hexData = nfcData.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
        debugPrint(hexData);
        // Send raw data using transceive (assuming the card supports it)
        String response = await FlutterNfcKit.transceive(hexData);

        _nfcMessage = 'Data written successfully: $response';
      } catch (e) {
        _nfcMessage = 'Error during NFC operation: $e';
      } finally {
        // Always stop the NFC session
        await FlutterNfcKit.finish();
        setState(() {});
      }
    // try {
    //     List<int> serialNumberBytes = _parseSerial(serialNumber);
    //     debugPrint(serialNumberBytes.toString());
    //     List<int> atqaBytes = _parseHex(atqa);
    //     List<int> sakBytes = _parseHex(sak);
    //     List<int> atsBytes = _parseHex(ats);

    //     List<int> nfcData = [
    //       ...serialNumberBytes,
    //       ...atqaBytes,
    //       ...sakBytes,
    //       ...atsBytes,
    //     ];
    //     Uint8List nfcDataBytes = Uint8List.fromList(nfcData);
    //     debugPrint('NFC Data: ${nfcDataBytes}');
    //     debugPrint('SL bytes: $serialNumberBytes');
    //     debugPrint('atqa bytes: $atqaBytes');
    //     debugPrint('sak bytes: $sakBytes');
    //     debugPrint('ats bytes: $atsBytes');

    //     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    //       try {
    //         var nfcA = NfcA.from(tag);
    //         var ndef=Ndef.from(tag);
    //         if(ndef!=null){
    //           debugPrint(ndef.isWritable.toString());
    //         }else{
    //           debugPrint('Ndef is null');
    //         }

    //         if (nfcA != null) {
    //           debugPrint('max write: ${nfcA.maxTransceiveLength}');
    //           debugPrint('data to write: ${nfcData.length}');
    //           debugPrint('timout: ${nfcA.timeout} ms');

    //           await nfcA.transceive(data:Uint8List.fromList(nfcData));
    //           setState(() {
    //             _nfcMessage = 'Data written successfully using NfcA!';
    //           });
    //         } else {
    //           setState(() {
    //             _nfcMessage = 'Unsupported NFC tag type';
    //           });
    //         }

    //         NfcManager.instance.stopSession();
    //       } catch (e) {
    //         setState(() {
    //           _nfcMessage = 'Error writing to NFC: $e';
    //         });
    //         debugPrint('Error writing to NFC: $e');
    //         NfcManager.instance.stopSession(errorMessage: e.toString());
    //       }
    //     });
    //   } catch (e) {
    //     setState(() {
    //       _nfcMessage = 'Invalid input format: $e';
    //     });
    //   }

    }
  }
void _startNfcSession() async {
    List<int> serialNumberBytes = _parseSerial(serialNumber);
    List<int> atqaBytes = _parseHex(atqa);
    List<int> sakBytes = _parseHex(sak);
    List<int> atsBytes = _parseHex(ats);

    List<int> nfcData = [
      ...serialNumberBytes,
      ...atqaBytes,
      ...sakBytes,
      ...atsBytes,
    ];
    try {
      // Start NFC session
      NFCTag tag = await FlutterNfcKit.poll();
      _nfcMessage = 'Tag discovered!';

      // Check if the tag is of NfcA type or supports transceive
      if (tag.type==NFCTagType.mifare_classic) {
        _nfcMessage = 'Writing raw data...';
        setState(() {});
        debugPrint('mifare classic writting...');
        // Send raw data using transceive
        String response = await FlutterNfcKit.transceive(nfcData.map((e) => e.toRadixString(16).padLeft(2, '0')).join());

        _nfcMessage = 'Data written successfully: $response';
      } else {
        _nfcMessage = 'Unsupported NFC tag type';
      }
    } catch (e) {
      _nfcMessage = 'Error during NFC operation: $e';
    } finally {
      // End NFC session
      await FlutterNfcKit.finish();
      setState(() {});
    }
  }

}
