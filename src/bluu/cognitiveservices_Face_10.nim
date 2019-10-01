
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Face Client
## version: 1.0
## termsOfService: (not provided)
## license: (not provided)
## 
## An API for face detection, verification, and identification.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-Face"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FaceDetectWithUrl_567890 = ref object of OpenApiRestCall_567668
proc url_FaceDetectWithUrl_567892(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceDetectWithUrl_567891(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Detect human faces in an image, return face rectangles, and optionally with faceIds, landmarks, and attributes.<br />
  ## * No image will be stored. Only the extracted face feature will be stored on server. The faceId is an identifier of the face feature and will be used in [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). The stored face feature(s) will expire and be deleted 24 hours after the original detection call.
  ## * Optional parameters include faceId, landmarks, and attributes. Attributes include age, gender, headPose, smile, facialHair, glasses, emotion, hair, makeup, occlusion, accessories, blur, exposure and noise. Some of the results returned for specific attributes may not be highly accurate.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * Up to 100 faces can be returned for an image. Faces are ranked by face rectangle size from large to small.
  ## * For optimal results when querying [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) ('returnFaceId' is true), please use faces that are: frontal, clear, and with a minimum size of 200x200 pixels (100 pixels between eyes).
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## * Different 'recognitionModel' values are provided. If follow-up operations like Verify, Identify, Find Similar are needed, please specify the recognition model with 'recognitionModel' parameter. The default value for 'recognitionModel' is 'recognition_01', if latest model needed, please explicitly specify the model you need in this parameter. Once specified, the detected faceIds will be associated with the specified recognition model. More details, please refer to [How to specify a recognition model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-recognition-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'recognition_01': | The default recognition model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). All those faceIds created before 2019 March are bonded with this recognition model. |
  ##   | 'recognition_02': | Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'. |
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   returnFaceAttributes: JArray
  ##                       : Analyze and return the one or more specified face attributes in the comma-separated string like "returnFaceAttributes=age,gender". Supported face attributes include age, gender, headPose, smile, facialHair, glasses and emotion. Note that each face attribute analysis has additional computational and time cost.
  ##   returnFaceId: JBool
  ##               : A value indicating whether the operation should return faceIds of detected faces.
  ##   returnFaceLandmarks: JBool
  ##                      : A value indicating whether the operation should return landmarks of the detected faces.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   recognitionModel: JString
  ##                   : Name of recognition model. Recognition model is used when the face features are extracted and associated with detected faceIds, (Large)FaceList or (Large)PersonGroup. A recognition model name can be provided when performing Face - Detect or (Large)FaceList - Create or (Large)PersonGroup - Create. The default value is 'recognition_01', if latest model needed, please explicitly specify the model you need.
  section = newJObject()
  var valid_568051 = query.getOrDefault("returnFaceAttributes")
  valid_568051 = validateParameter(valid_568051, JArray, required = false,
                                 default = nil)
  if valid_568051 != nil:
    section.add "returnFaceAttributes", valid_568051
  var valid_568065 = query.getOrDefault("returnFaceId")
  valid_568065 = validateParameter(valid_568065, JBool, required = false,
                                 default = newJBool(true))
  if valid_568065 != nil:
    section.add "returnFaceId", valid_568065
  var valid_568066 = query.getOrDefault("returnFaceLandmarks")
  valid_568066 = validateParameter(valid_568066, JBool, required = false,
                                 default = newJBool(false))
  if valid_568066 != nil:
    section.add "returnFaceLandmarks", valid_568066
  var valid_568067 = query.getOrDefault("detectionModel")
  valid_568067 = validateParameter(valid_568067, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_568067 != nil:
    section.add "detectionModel", valid_568067
  var valid_568068 = query.getOrDefault("returnRecognitionModel")
  valid_568068 = validateParameter(valid_568068, JBool, required = false,
                                 default = newJBool(false))
  if valid_568068 != nil:
    section.add "returnRecognitionModel", valid_568068
  var valid_568069 = query.getOrDefault("recognitionModel")
  valid_568069 = validateParameter(valid_568069, JString, required = false,
                                 default = newJString("recognition_01"))
  if valid_568069 != nil:
    section.add "recognitionModel", valid_568069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568093: Call_FaceDetectWithUrl_567890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detect human faces in an image, return face rectangles, and optionally with faceIds, landmarks, and attributes.<br />
  ## * No image will be stored. Only the extracted face feature will be stored on server. The faceId is an identifier of the face feature and will be used in [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). The stored face feature(s) will expire and be deleted 24 hours after the original detection call.
  ## * Optional parameters include faceId, landmarks, and attributes. Attributes include age, gender, headPose, smile, facialHair, glasses, emotion, hair, makeup, occlusion, accessories, blur, exposure and noise. Some of the results returned for specific attributes may not be highly accurate.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * Up to 100 faces can be returned for an image. Faces are ranked by face rectangle size from large to small.
  ## * For optimal results when querying [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) ('returnFaceId' is true), please use faces that are: frontal, clear, and with a minimum size of 200x200 pixels (100 pixels between eyes).
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## * Different 'recognitionModel' values are provided. If follow-up operations like Verify, Identify, Find Similar are needed, please specify the recognition model with 'recognitionModel' parameter. The default value for 'recognitionModel' is 'recognition_01', if latest model needed, please explicitly specify the model you need in this parameter. Once specified, the detected faceIds will be associated with the specified recognition model. More details, please refer to [How to specify a recognition model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-recognition-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'recognition_01': | The default recognition model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). All those faceIds created before 2019 March are bonded with this recognition model. |
  ##   | 'recognition_02': | Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'. |
  ## 
  let valid = call_568093.validator(path, query, header, formData, body)
  let scheme = call_568093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568093.url(scheme.get, call_568093.host, call_568093.base,
                         call_568093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568093, url, valid)

proc call*(call_568164: Call_FaceDetectWithUrl_567890; ImageUrl: JsonNode;
          returnFaceAttributes: JsonNode = nil; returnFaceId: bool = true;
          returnFaceLandmarks: bool = false;
          detectionModel: string = "detection_01";
          returnRecognitionModel: bool = false;
          recognitionModel: string = "recognition_01"): Recallable =
  ## faceDetectWithUrl
  ## Detect human faces in an image, return face rectangles, and optionally with faceIds, landmarks, and attributes.<br />
  ## * No image will be stored. Only the extracted face feature will be stored on server. The faceId is an identifier of the face feature and will be used in [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). The stored face feature(s) will expire and be deleted 24 hours after the original detection call.
  ## * Optional parameters include faceId, landmarks, and attributes. Attributes include age, gender, headPose, smile, facialHair, glasses, emotion, hair, makeup, occlusion, accessories, blur, exposure and noise. Some of the results returned for specific attributes may not be highly accurate.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * Up to 100 faces can be returned for an image. Faces are ranked by face rectangle size from large to small.
  ## * For optimal results when querying [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) ('returnFaceId' is true), please use faces that are: frontal, clear, and with a minimum size of 200x200 pixels (100 pixels between eyes).
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## * Different 'recognitionModel' values are provided. If follow-up operations like Verify, Identify, Find Similar are needed, please specify the recognition model with 'recognitionModel' parameter. The default value for 'recognitionModel' is 'recognition_01', if latest model needed, please explicitly specify the model you need in this parameter. Once specified, the detected faceIds will be associated with the specified recognition model. More details, please refer to [How to specify a recognition model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-recognition-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'recognition_01': | The default recognition model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). All those faceIds created before 2019 March are bonded with this recognition model. |
  ##   | 'recognition_02': | Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'. |
  ##   returnFaceAttributes: JArray
  ##                       : Analyze and return the one or more specified face attributes in the comma-separated string like "returnFaceAttributes=age,gender". Supported face attributes include age, gender, headPose, smile, facialHair, glasses and emotion. Note that each face attribute analysis has additional computational and time cost.
  ##   returnFaceId: bool
  ##               : A value indicating whether the operation should return faceIds of detected faces.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   returnFaceLandmarks: bool
  ##                      : A value indicating whether the operation should return landmarks of the detected faces.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   recognitionModel: string
  ##                   : Name of recognition model. Recognition model is used when the face features are extracted and associated with detected faceIds, (Large)FaceList or (Large)PersonGroup. A recognition model name can be provided when performing Face - Detect or (Large)FaceList - Create or (Large)PersonGroup - Create. The default value is 'recognition_01', if latest model needed, please explicitly specify the model you need.
  var query_568165 = newJObject()
  var body_568167 = newJObject()
  if returnFaceAttributes != nil:
    query_568165.add "returnFaceAttributes", returnFaceAttributes
  add(query_568165, "returnFaceId", newJBool(returnFaceId))
  if ImageUrl != nil:
    body_568167 = ImageUrl
  add(query_568165, "returnFaceLandmarks", newJBool(returnFaceLandmarks))
  add(query_568165, "detectionModel", newJString(detectionModel))
  add(query_568165, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_568165, "recognitionModel", newJString(recognitionModel))
  result = call_568164.call(nil, query_568165, nil, nil, body_568167)

var faceDetectWithUrl* = Call_FaceDetectWithUrl_567890(name: "faceDetectWithUrl",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/detect",
    validator: validate_FaceDetectWithUrl_567891, base: "",
    url: url_FaceDetectWithUrl_567892, schemes: {Scheme.Https})
type
  Call_FaceListList_568206 = ref object of OpenApiRestCall_567668
proc url_FaceListList_568208(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceListList_568207(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List face lists’ faceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside faceList use [FaceList - Get](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524c)
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_568209 = query.getOrDefault("returnRecognitionModel")
  valid_568209 = validateParameter(valid_568209, JBool, required = false,
                                 default = newJBool(false))
  if valid_568209 != nil:
    section.add "returnRecognitionModel", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_FaceListList_568206; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List face lists’ faceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside faceList use [FaceList - Get](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524c)
  ## 
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_FaceListList_568206;
          returnRecognitionModel: bool = false): Recallable =
  ## faceListList
  ## List face lists’ faceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside faceList use [FaceList - Get](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524c)
  ## 
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var query_568212 = newJObject()
  add(query_568212, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_568211.call(nil, query_568212, nil, nil, nil)

var faceListList* = Call_FaceListList_568206(name: "faceListList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/facelists",
    validator: validate_FaceListList_568207, base: "", url: url_FaceListList_568208,
    schemes: {Scheme.Https})
type
  Call_FaceListCreate_568236 = ref object of OpenApiRestCall_567668
proc url_FaceListCreate_568238(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListCreate_568237(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create an empty face list with user-specified faceListId, name, an optional userData and recognitionModel. Up to 64 face lists are allowed in one subscription.
  ## <br /> Face list is a list of faces, up to 1,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250) to import the faces. No image will be stored. Only the extracted face features are stored on server until [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> Please consider [LargeFaceList](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) when the face number is large. It can support up to 1,000,000 faces.
  ## <br />'recognitionModel' should be specified to associate with this face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing face list will use the recognition model that's already associated with the collection. Existing face features in a face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [FaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b). All those face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_568239 = path.getOrDefault("faceListId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "faceListId", valid_568239
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating a face list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568241: Call_FaceListCreate_568236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an empty face list with user-specified faceListId, name, an optional userData and recognitionModel. Up to 64 face lists are allowed in one subscription.
  ## <br /> Face list is a list of faces, up to 1,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250) to import the faces. No image will be stored. Only the extracted face features are stored on server until [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> Please consider [LargeFaceList](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) when the face number is large. It can support up to 1,000,000 faces.
  ## <br />'recognitionModel' should be specified to associate with this face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing face list will use the recognition model that's already associated with the collection. Existing face features in a face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [FaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b). All those face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_FaceListCreate_568236; faceListId: string;
          body: JsonNode): Recallable =
  ## faceListCreate
  ## Create an empty face list with user-specified faceListId, name, an optional userData and recognitionModel. Up to 64 face lists are allowed in one subscription.
  ## <br /> Face list is a list of faces, up to 1,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250) to import the faces. No image will be stored. Only the extracted face features are stored on server until [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> Please consider [LargeFaceList](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) when the face number is large. It can support up to 1,000,000 faces.
  ## <br />'recognitionModel' should be specified to associate with this face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing face list will use the recognition model that's already associated with the collection. Existing face features in a face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [FaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b). All those face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   body: JObject (required)
  ##       : Request body for creating a face list.
  var path_568243 = newJObject()
  var body_568244 = newJObject()
  add(path_568243, "faceListId", newJString(faceListId))
  if body != nil:
    body_568244 = body
  result = call_568242.call(path_568243, nil, nil, nil, body_568244)

var faceListCreate* = Call_FaceListCreate_568236(name: "faceListCreate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/facelists/{faceListId}",
    validator: validate_FaceListCreate_568237, base: "", url: url_FaceListCreate_568238,
    schemes: {Scheme.Https})
type
  Call_FaceListGet_568213 = ref object of OpenApiRestCall_567668
proc url_FaceListGet_568215(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListGet_568214(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a face list’s faceListId, name, userData, recognitionModel and faces in the face list.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_568230 = path.getOrDefault("faceListId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "faceListId", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_568231 = query.getOrDefault("returnRecognitionModel")
  valid_568231 = validateParameter(valid_568231, JBool, required = false,
                                 default = newJBool(false))
  if valid_568231 != nil:
    section.add "returnRecognitionModel", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_FaceListGet_568213; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a face list’s faceListId, name, userData, recognitionModel and faces in the face list.
  ## 
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_FaceListGet_568213; faceListId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## faceListGet
  ## Retrieve a face list’s faceListId, name, userData, recognitionModel and faces in the face list.
  ## 
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(path_568234, "faceListId", newJString(faceListId))
  add(query_568235, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var faceListGet* = Call_FaceListGet_568213(name: "faceListGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/facelists/{faceListId}",
                                        validator: validate_FaceListGet_568214,
                                        base: "", url: url_FaceListGet_568215,
                                        schemes: {Scheme.Https})
type
  Call_FaceListUpdate_568252 = ref object of OpenApiRestCall_567668
proc url_FaceListUpdate_568254(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListUpdate_568253(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update information of a face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_568255 = path.getOrDefault("faceListId")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "faceListId", valid_568255
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating a face list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_FaceListUpdate_568252; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update information of a face list.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_FaceListUpdate_568252; faceListId: string;
          body: JsonNode): Recallable =
  ## faceListUpdate
  ## Update information of a face list.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   body: JObject (required)
  ##       : Request body for updating a face list.
  var path_568259 = newJObject()
  var body_568260 = newJObject()
  add(path_568259, "faceListId", newJString(faceListId))
  if body != nil:
    body_568260 = body
  result = call_568258.call(path_568259, nil, nil, nil, body_568260)

var faceListUpdate* = Call_FaceListUpdate_568252(name: "faceListUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/facelists/{faceListId}", validator: validate_FaceListUpdate_568253,
    base: "", url: url_FaceListUpdate_568254, schemes: {Scheme.Https})
type
  Call_FaceListDelete_568245 = ref object of OpenApiRestCall_567668
proc url_FaceListDelete_568247(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListDelete_568246(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a specified face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_568248 = path.getOrDefault("faceListId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "faceListId", valid_568248
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_FaceListDelete_568245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a specified face list.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_FaceListDelete_568245; faceListId: string): Recallable =
  ## faceListDelete
  ## Delete a specified face list.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  var path_568251 = newJObject()
  add(path_568251, "faceListId", newJString(faceListId))
  result = call_568250.call(path_568251, nil, nil, nil, nil)

var faceListDelete* = Call_FaceListDelete_568245(name: "faceListDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/facelists/{faceListId}", validator: validate_FaceListDelete_568246,
    base: "", url: url_FaceListDelete_568247, schemes: {Scheme.Https})
type
  Call_FaceListAddFaceFromUrl_568261 = ref object of OpenApiRestCall_567668
proc url_FaceListAddFaceFromUrl_568263(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListAddFaceFromUrl_568262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a specified face list, up to 1,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [FaceList - Delete Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395251) or [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better detection and recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_568264 = path.getOrDefault("faceListId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "faceListId", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  section = newJObject()
  var valid_568265 = query.getOrDefault("userData")
  valid_568265 = validateParameter(valid_568265, JString, required = false,
                                 default = nil)
  if valid_568265 != nil:
    section.add "userData", valid_568265
  var valid_568266 = query.getOrDefault("detectionModel")
  valid_568266 = validateParameter(valid_568266, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_568266 != nil:
    section.add "detectionModel", valid_568266
  var valid_568267 = query.getOrDefault("targetFace")
  valid_568267 = validateParameter(valid_568267, JArray, required = false,
                                 default = nil)
  if valid_568267 != nil:
    section.add "targetFace", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_FaceListAddFaceFromUrl_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a face to a specified face list, up to 1,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [FaceList - Delete Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395251) or [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better detection and recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_FaceListAddFaceFromUrl_568261; faceListId: string;
          ImageUrl: JsonNode; userData: string = "";
          detectionModel: string = "detection_01"; targetFace: JsonNode = nil): Recallable =
  ## faceListAddFaceFromUrl
  ## Add a face to a specified face list, up to 1,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [FaceList - Delete Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395251) or [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better detection and recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  var path_568271 = newJObject()
  var query_568272 = newJObject()
  var body_568273 = newJObject()
  add(path_568271, "faceListId", newJString(faceListId))
  add(query_568272, "userData", newJString(userData))
  if ImageUrl != nil:
    body_568273 = ImageUrl
  add(query_568272, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_568272.add "targetFace", targetFace
  result = call_568270.call(path_568271, query_568272, nil, nil, body_568273)

var faceListAddFaceFromUrl* = Call_FaceListAddFaceFromUrl_568261(
    name: "faceListAddFaceFromUrl", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/facelists/{faceListId}/persistedfaces",
    validator: validate_FaceListAddFaceFromUrl_568262, base: "",
    url: url_FaceListAddFaceFromUrl_568263, schemes: {Scheme.Https})
type
  Call_FaceListDeleteFace_568274 = ref object of OpenApiRestCall_567668
proc url_FaceListDeleteFace_568276(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListDeleteFace_568275(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_568277 = path.getOrDefault("faceListId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "faceListId", valid_568277
  var valid_568278 = path.getOrDefault("persistedFaceId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "persistedFaceId", valid_568278
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_FaceListDeleteFace_568274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_FaceListDeleteFace_568274; faceListId: string;
          persistedFaceId: string): Recallable =
  ## faceListDeleteFace
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  var path_568281 = newJObject()
  add(path_568281, "faceListId", newJString(faceListId))
  add(path_568281, "persistedFaceId", newJString(persistedFaceId))
  result = call_568280.call(path_568281, nil, nil, nil, nil)

var faceListDeleteFace* = Call_FaceListDeleteFace_568274(
    name: "faceListDeleteFace", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/facelists/{faceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_FaceListDeleteFace_568275, base: "",
    url: url_FaceListDeleteFace_568276, schemes: {Scheme.Https})
type
  Call_FaceFindSimilar_568282 = ref object of OpenApiRestCall_567668
proc url_FaceFindSimilar_568284(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceFindSimilar_568283(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Given query face's faceId, to search the similar-looking faces from a faceId array, a face list or a large face list. faceId array contains the faces created by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), which will expire 24 hours after creation. A "faceListId" is created by [FaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b) containing persistedFaceIds that will not expire. And a "largeFaceListId" is created by [LargeFaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) containing persistedFaceIds that will also not expire. Depending on the input the returned similar faces list contains faceIds or persistedFaceIds ranked by similarity.
  ## <br/>Find similar has two working modes, "matchPerson" and "matchFace". "matchPerson" is the default mode that it tries to find faces of the same person as possible by using internal same-person thresholds. It is useful to find a known person's other photos. Note that an empty list will be returned if no faces pass the internal thresholds. "matchFace" mode ignores same-person thresholds and returns ranked similar faces anyway, even the similarity is low. It can be used in the cases like searching celebrity-looking faces.
  ## <br/>The 'recognitionModel' associated with the query face's faceId should be the same as the 'recognitionModel' used by the target faceId array, face list or large face list.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for Find Similar.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_FaceFindSimilar_568282; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Given query face's faceId, to search the similar-looking faces from a faceId array, a face list or a large face list. faceId array contains the faces created by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), which will expire 24 hours after creation. A "faceListId" is created by [FaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b) containing persistedFaceIds that will not expire. And a "largeFaceListId" is created by [LargeFaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) containing persistedFaceIds that will also not expire. Depending on the input the returned similar faces list contains faceIds or persistedFaceIds ranked by similarity.
  ## <br/>Find similar has two working modes, "matchPerson" and "matchFace". "matchPerson" is the default mode that it tries to find faces of the same person as possible by using internal same-person thresholds. It is useful to find a known person's other photos. Note that an empty list will be returned if no faces pass the internal thresholds. "matchFace" mode ignores same-person thresholds and returns ranked similar faces anyway, even the similarity is low. It can be used in the cases like searching celebrity-looking faces.
  ## <br/>The 'recognitionModel' associated with the query face's faceId should be the same as the 'recognitionModel' used by the target faceId array, face list or large face list.
  ## 
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_FaceFindSimilar_568282; body: JsonNode): Recallable =
  ## faceFindSimilar
  ## Given query face's faceId, to search the similar-looking faces from a faceId array, a face list or a large face list. faceId array contains the faces created by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), which will expire 24 hours after creation. A "faceListId" is created by [FaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b) containing persistedFaceIds that will not expire. And a "largeFaceListId" is created by [LargeFaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) containing persistedFaceIds that will also not expire. Depending on the input the returned similar faces list contains faceIds or persistedFaceIds ranked by similarity.
  ## <br/>Find similar has two working modes, "matchPerson" and "matchFace". "matchPerson" is the default mode that it tries to find faces of the same person as possible by using internal same-person thresholds. It is useful to find a known person's other photos. Note that an empty list will be returned if no faces pass the internal thresholds. "matchFace" mode ignores same-person thresholds and returns ranked similar faces anyway, even the similarity is low. It can be used in the cases like searching celebrity-looking faces.
  ## <br/>The 'recognitionModel' associated with the query face's faceId should be the same as the 'recognitionModel' used by the target faceId array, face list or large face list.
  ## 
  ##   body: JObject (required)
  ##       : Request body for Find Similar.
  var body_568288 = newJObject()
  if body != nil:
    body_568288 = body
  result = call_568287.call(nil, nil, nil, nil, body_568288)

var faceFindSimilar* = Call_FaceFindSimilar_568282(name: "faceFindSimilar",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/findsimilars",
    validator: validate_FaceFindSimilar_568283, base: "", url: url_FaceFindSimilar_568284,
    schemes: {Scheme.Https})
type
  Call_FaceGroup_568289 = ref object of OpenApiRestCall_567668
proc url_FaceGroup_568291(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceGroup_568290(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Divide candidate faces into groups based on face similarity.<br />
  ## * The output is one or more disjointed face groups and a messyGroup. A face group contains faces that have similar looking, often of the same person. Face groups are ranked by group size, i.e. number of faces. Notice that faces belonging to a same person might be split into several groups in the result.
  ## * MessyGroup is a special face group containing faces that cannot find any similar counterpart face from original faces. The messyGroup will not appear in the result if all faces found their counterparts.
  ## * Group API needs at least 2 candidate faces and 1000 at most. We suggest to try [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a) when you only have 2 candidate faces.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for grouping.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_FaceGroup_568289; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Divide candidate faces into groups based on face similarity.<br />
  ## * The output is one or more disjointed face groups and a messyGroup. A face group contains faces that have similar looking, often of the same person. Face groups are ranked by group size, i.e. number of faces. Notice that faces belonging to a same person might be split into several groups in the result.
  ## * MessyGroup is a special face group containing faces that cannot find any similar counterpart face from original faces. The messyGroup will not appear in the result if all faces found their counterparts.
  ## * Group API needs at least 2 candidate faces and 1000 at most. We suggest to try [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a) when you only have 2 candidate faces.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same.
  ## 
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_FaceGroup_568289; body: JsonNode): Recallable =
  ## faceGroup
  ## Divide candidate faces into groups based on face similarity.<br />
  ## * The output is one or more disjointed face groups and a messyGroup. A face group contains faces that have similar looking, often of the same person. Face groups are ranked by group size, i.e. number of faces. Notice that faces belonging to a same person might be split into several groups in the result.
  ## * MessyGroup is a special face group containing faces that cannot find any similar counterpart face from original faces. The messyGroup will not appear in the result if all faces found their counterparts.
  ## * Group API needs at least 2 candidate faces and 1000 at most. We suggest to try [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a) when you only have 2 candidate faces.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same.
  ## 
  ##   body: JObject (required)
  ##       : Request body for grouping.
  var body_568295 = newJObject()
  if body != nil:
    body_568295 = body
  result = call_568294.call(nil, nil, nil, nil, body_568295)

var faceGroup* = Call_FaceGroup_568289(name: "faceGroup", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/group",
                                    validator: validate_FaceGroup_568290,
                                    base: "", url: url_FaceGroup_568291,
                                    schemes: {Scheme.Https})
type
  Call_FaceIdentify_568296 = ref object of OpenApiRestCall_567668
proc url_FaceIdentify_568298(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceIdentify_568297(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## 1-to-many identification to find the closest matches of the specific query person face from a person group or large person group.
  ## <br/> For each face in the faceIds array, Face Identify will compute similarities between the query face and all the faces in the person group (given by personGroupId) or large person group (given by largePersonGroupId), and return candidate person(s) for that face ranked by similarity confidence. The person group/large person group should be trained to make it ready for identification. See more in [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) and [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4).
  ## <br/>
  ##  
  ## Remarks:<br />
  ## * The algorithm allows more than one face to be identified independently at the same request, but no more than 10 faces.
  ## * Each person in the person group/large person group could have more than one face, but no more than 248 faces.
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Number of candidates returned is restricted by maxNumOfCandidatesReturned and confidenceThreshold. If no person is identified, the returned candidates will be an empty array.
  ## * Try [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) when you need to find similar faces from a face list/large face list instead of a person group/large person group.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target person group or large person group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for identify operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_FaceIdentify_568296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## 1-to-many identification to find the closest matches of the specific query person face from a person group or large person group.
  ## <br/> For each face in the faceIds array, Face Identify will compute similarities between the query face and all the faces in the person group (given by personGroupId) or large person group (given by largePersonGroupId), and return candidate person(s) for that face ranked by similarity confidence. The person group/large person group should be trained to make it ready for identification. See more in [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) and [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4).
  ## <br/>
  ##  
  ## Remarks:<br />
  ## * The algorithm allows more than one face to be identified independently at the same request, but no more than 10 faces.
  ## * Each person in the person group/large person group could have more than one face, but no more than 248 faces.
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Number of candidates returned is restricted by maxNumOfCandidatesReturned and confidenceThreshold. If no person is identified, the returned candidates will be an empty array.
  ## * Try [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) when you need to find similar faces from a face list/large face list instead of a person group/large person group.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target person group or large person group.
  ## 
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_FaceIdentify_568296; body: JsonNode): Recallable =
  ## faceIdentify
  ## 1-to-many identification to find the closest matches of the specific query person face from a person group or large person group.
  ## <br/> For each face in the faceIds array, Face Identify will compute similarities between the query face and all the faces in the person group (given by personGroupId) or large person group (given by largePersonGroupId), and return candidate person(s) for that face ranked by similarity confidence. The person group/large person group should be trained to make it ready for identification. See more in [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) and [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4).
  ## <br/>
  ##  
  ## Remarks:<br />
  ## * The algorithm allows more than one face to be identified independently at the same request, but no more than 10 faces.
  ## * Each person in the person group/large person group could have more than one face, but no more than 248 faces.
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Number of candidates returned is restricted by maxNumOfCandidatesReturned and confidenceThreshold. If no person is identified, the returned candidates will be an empty array.
  ## * Try [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) when you need to find similar faces from a face list/large face list instead of a person group/large person group.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target person group or large person group.
  ## 
  ##   body: JObject (required)
  ##       : Request body for identify operation.
  var body_568302 = newJObject()
  if body != nil:
    body_568302 = body
  result = call_568301.call(nil, nil, nil, nil, body_568302)

var faceIdentify* = Call_FaceIdentify_568296(name: "faceIdentify",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/identify",
    validator: validate_FaceIdentify_568297, base: "", url: url_FaceIdentify_568298,
    schemes: {Scheme.Https})
type
  Call_LargeFaceListList_568303 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListList_568305(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LargeFaceListList_568304(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List large face lists’ information of largeFaceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside largeFaceList use [LargeFaceList Face - Get](/docs/services/563879b61984550e40cbbe8d/operations/5a158cf2d2de3616c086f2d5)<br />
  ## * Large face lists are stored in alphabetical order of largeFaceListId.
  ## * "start" parameter (string, optional) is a user-provided largeFaceListId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person lists: "list1", ..., "list5".
  ## <br /> "start=&top=" will return all 5 lists.
  ## <br /> "start=&top=2" will return "list1", "list2".
  ## <br /> "start=list2&top=3" will return "list3", "list4", "list5".
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_568306 = query.getOrDefault("returnRecognitionModel")
  valid_568306 = validateParameter(valid_568306, JBool, required = false,
                                 default = newJBool(false))
  if valid_568306 != nil:
    section.add "returnRecognitionModel", valid_568306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_LargeFaceListList_568303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List large face lists’ information of largeFaceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside largeFaceList use [LargeFaceList Face - Get](/docs/services/563879b61984550e40cbbe8d/operations/5a158cf2d2de3616c086f2d5)<br />
  ## * Large face lists are stored in alphabetical order of largeFaceListId.
  ## * "start" parameter (string, optional) is a user-provided largeFaceListId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person lists: "list1", ..., "list5".
  ## <br /> "start=&top=" will return all 5 lists.
  ## <br /> "start=&top=2" will return "list1", "list2".
  ## <br /> "start=list2&top=3" will return "list3", "list4", "list5".
  ## 
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_LargeFaceListList_568303;
          returnRecognitionModel: bool = false): Recallable =
  ## largeFaceListList
  ## List large face lists’ information of largeFaceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside largeFaceList use [LargeFaceList Face - Get](/docs/services/563879b61984550e40cbbe8d/operations/5a158cf2d2de3616c086f2d5)<br />
  ## * Large face lists are stored in alphabetical order of largeFaceListId.
  ## * "start" parameter (string, optional) is a user-provided largeFaceListId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person lists: "list1", ..., "list5".
  ## <br /> "start=&top=" will return all 5 lists.
  ## <br /> "start=&top=2" will return "list1", "list2".
  ## <br /> "start=list2&top=3" will return "list3", "list4", "list5".
  ## 
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var query_568309 = newJObject()
  add(query_568309, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_568308.call(nil, query_568309, nil, nil, nil)

var largeFaceListList* = Call_LargeFaceListList_568303(name: "largeFaceListList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/largefacelists",
    validator: validate_LargeFaceListList_568304, base: "",
    url: url_LargeFaceListList_568305, schemes: {Scheme.Https})
type
  Call_LargeFaceListCreate_568319 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListCreate_568321(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListCreate_568320(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create an empty large face list with user-specified largeFaceListId, name, an optional userData and recognitionModel.
  ## <br /> Large face list is a list of faces, up to 1,000,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [LargeFaceList Face - Add](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3) to import the faces and [LargeFaceList - Train](/docs/services/563879b61984550e40cbbe8d/operations/5a158422d2de3616c086f2d1) to make it ready for [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). No image will be stored. Only the extracted face features are stored on server until [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br/>'recognitionModel' should be specified to associate with this large face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large face list will use the recognition model that's already associated with the collection. Existing face features in a large face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargeFaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc). All those large face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large face list quota:
  ## * Free-tier subscription quota: 64 large face lists.
  ## * S0-tier subscription quota: 1,000,000 large face lists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568322 = path.getOrDefault("largeFaceListId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "largeFaceListId", valid_568322
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating a large face list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_LargeFaceListCreate_568319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an empty large face list with user-specified largeFaceListId, name, an optional userData and recognitionModel.
  ## <br /> Large face list is a list of faces, up to 1,000,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [LargeFaceList Face - Add](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3) to import the faces and [LargeFaceList - Train](/docs/services/563879b61984550e40cbbe8d/operations/5a158422d2de3616c086f2d1) to make it ready for [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). No image will be stored. Only the extracted face features are stored on server until [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br/>'recognitionModel' should be specified to associate with this large face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large face list will use the recognition model that's already associated with the collection. Existing face features in a large face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargeFaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc). All those large face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large face list quota:
  ## * Free-tier subscription quota: 64 large face lists.
  ## * S0-tier subscription quota: 1,000,000 large face lists.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_LargeFaceListCreate_568319; largeFaceListId: string;
          body: JsonNode): Recallable =
  ## largeFaceListCreate
  ## Create an empty large face list with user-specified largeFaceListId, name, an optional userData and recognitionModel.
  ## <br /> Large face list is a list of faces, up to 1,000,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [LargeFaceList Face - Add](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3) to import the faces and [LargeFaceList - Train](/docs/services/563879b61984550e40cbbe8d/operations/5a158422d2de3616c086f2d1) to make it ready for [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). No image will be stored. Only the extracted face features are stored on server until [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br/>'recognitionModel' should be specified to associate with this large face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large face list will use the recognition model that's already associated with the collection. Existing face features in a large face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargeFaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc). All those large face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large face list quota:
  ## * Free-tier subscription quota: 64 large face lists.
  ## * S0-tier subscription quota: 1,000,000 large face lists.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   body: JObject (required)
  ##       : Request body for creating a large face list.
  var path_568326 = newJObject()
  var body_568327 = newJObject()
  add(path_568326, "largeFaceListId", newJString(largeFaceListId))
  if body != nil:
    body_568327 = body
  result = call_568325.call(path_568326, nil, nil, nil, body_568327)

var largeFaceListCreate* = Call_LargeFaceListCreate_568319(
    name: "largeFaceListCreate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListCreate_568320, base: "",
    url: url_LargeFaceListCreate_568321, schemes: {Scheme.Https})
type
  Call_LargeFaceListGet_568310 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListGet_568312(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListGet_568311(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieve a large face list’s largeFaceListId, name, userData and recognitionModel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568313 = path.getOrDefault("largeFaceListId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "largeFaceListId", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_568314 = query.getOrDefault("returnRecognitionModel")
  valid_568314 = validateParameter(valid_568314, JBool, required = false,
                                 default = newJBool(false))
  if valid_568314 != nil:
    section.add "returnRecognitionModel", valid_568314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_LargeFaceListGet_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a large face list’s largeFaceListId, name, userData and recognitionModel.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_LargeFaceListGet_568310; largeFaceListId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## largeFaceListGet
  ## Retrieve a large face list’s largeFaceListId, name, userData and recognitionModel.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  add(path_568317, "largeFaceListId", newJString(largeFaceListId))
  add(query_568318, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_568316.call(path_568317, query_568318, nil, nil, nil)

var largeFaceListGet* = Call_LargeFaceListGet_568310(name: "largeFaceListGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListGet_568311, base: "",
    url: url_LargeFaceListGet_568312, schemes: {Scheme.Https})
type
  Call_LargeFaceListUpdate_568335 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListUpdate_568337(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListUpdate_568336(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Update information of a large face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568338 = path.getOrDefault("largeFaceListId")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "largeFaceListId", valid_568338
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating a large face list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_LargeFaceListUpdate_568335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update information of a large face list.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_LargeFaceListUpdate_568335; largeFaceListId: string;
          body: JsonNode): Recallable =
  ## largeFaceListUpdate
  ## Update information of a large face list.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   body: JObject (required)
  ##       : Request body for updating a large face list.
  var path_568342 = newJObject()
  var body_568343 = newJObject()
  add(path_568342, "largeFaceListId", newJString(largeFaceListId))
  if body != nil:
    body_568343 = body
  result = call_568341.call(path_568342, nil, nil, nil, body_568343)

var largeFaceListUpdate* = Call_LargeFaceListUpdate_568335(
    name: "largeFaceListUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListUpdate_568336, base: "",
    url: url_LargeFaceListUpdate_568337, schemes: {Scheme.Https})
type
  Call_LargeFaceListDelete_568328 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListDelete_568330(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListDelete_568329(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete a specified large face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568331 = path.getOrDefault("largeFaceListId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "largeFaceListId", valid_568331
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568332: Call_LargeFaceListDelete_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a specified large face list.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_LargeFaceListDelete_568328; largeFaceListId: string): Recallable =
  ## largeFaceListDelete
  ## Delete a specified large face list.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_568334 = newJObject()
  add(path_568334, "largeFaceListId", newJString(largeFaceListId))
  result = call_568333.call(path_568334, nil, nil, nil, nil)

var largeFaceListDelete* = Call_LargeFaceListDelete_568328(
    name: "largeFaceListDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListDelete_568329, base: "",
    url: url_LargeFaceListDelete_568330, schemes: {Scheme.Https})
type
  Call_LargeFaceListAddFaceFromUrl_568354 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListAddFaceFromUrl_568356(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListAddFaceFromUrl_568355(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a specified large face list, up to 1,000,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargeFaceList Face - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a158c8ad2de3616c086f2d4) or [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargeFaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## Quota:
  ## * Free-tier subscription quota: 1,000 faces per large face list.
  ## * S0-tier subscription quota: 1,000,000 faces per large face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568357 = path.getOrDefault("largeFaceListId")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "largeFaceListId", valid_568357
  result.add "path", section
  ## parameters in `query` object:
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  section = newJObject()
  var valid_568358 = query.getOrDefault("userData")
  valid_568358 = validateParameter(valid_568358, JString, required = false,
                                 default = nil)
  if valid_568358 != nil:
    section.add "userData", valid_568358
  var valid_568359 = query.getOrDefault("detectionModel")
  valid_568359 = validateParameter(valid_568359, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_568359 != nil:
    section.add "detectionModel", valid_568359
  var valid_568360 = query.getOrDefault("targetFace")
  valid_568360 = validateParameter(valid_568360, JArray, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "targetFace", valid_568360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_LargeFaceListAddFaceFromUrl_568354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a face to a specified large face list, up to 1,000,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargeFaceList Face - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a158c8ad2de3616c086f2d4) or [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargeFaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## Quota:
  ## * Free-tier subscription quota: 1,000 faces per large face list.
  ## * S0-tier subscription quota: 1,000,000 faces per large face list.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_LargeFaceListAddFaceFromUrl_568354;
          largeFaceListId: string; ImageUrl: JsonNode; userData: string = "";
          detectionModel: string = "detection_01"; targetFace: JsonNode = nil): Recallable =
  ## largeFaceListAddFaceFromUrl
  ## Add a face to a specified large face list, up to 1,000,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargeFaceList Face - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a158c8ad2de3616c086f2d4) or [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargeFaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## Quota:
  ## * Free-tier subscription quota: 1,000 faces per large face list.
  ## * S0-tier subscription quota: 1,000,000 faces per large face list.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  var body_568366 = newJObject()
  add(path_568364, "largeFaceListId", newJString(largeFaceListId))
  add(query_568365, "userData", newJString(userData))
  if ImageUrl != nil:
    body_568366 = ImageUrl
  add(query_568365, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_568365.add "targetFace", targetFace
  result = call_568363.call(path_568364, query_568365, nil, nil, body_568366)

var largeFaceListAddFaceFromUrl* = Call_LargeFaceListAddFaceFromUrl_568354(
    name: "largeFaceListAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/persistedfaces",
    validator: validate_LargeFaceListAddFaceFromUrl_568355, base: "",
    url: url_LargeFaceListAddFaceFromUrl_568356, schemes: {Scheme.Https})
type
  Call_LargeFaceListListFaces_568344 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListListFaces_568346(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListListFaces_568345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all faces in a large face list, and retrieve face information (including userData and persistedFaceIds of registered faces of the face).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568347 = path.getOrDefault("largeFaceListId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "largeFaceListId", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : Number of faces to return starting with the face id indicated by the 'start' parameter.
  ##   start: JString
  ##        : Starting face id to return (used to list a range of faces).
  section = newJObject()
  var valid_568348 = query.getOrDefault("top")
  valid_568348 = validateParameter(valid_568348, JInt, required = false, default = nil)
  if valid_568348 != nil:
    section.add "top", valid_568348
  var valid_568349 = query.getOrDefault("start")
  valid_568349 = validateParameter(valid_568349, JString, required = false,
                                 default = nil)
  if valid_568349 != nil:
    section.add "start", valid_568349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568350: Call_LargeFaceListListFaces_568344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all faces in a large face list, and retrieve face information (including userData and persistedFaceIds of registered faces of the face).
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_LargeFaceListListFaces_568344;
          largeFaceListId: string; top: int = 0; start: string = ""): Recallable =
  ## largeFaceListListFaces
  ## List all faces in a large face list, and retrieve face information (including userData and persistedFaceIds of registered faces of the face).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   top: int
  ##      : Number of faces to return starting with the face id indicated by the 'start' parameter.
  ##   start: string
  ##        : Starting face id to return (used to list a range of faces).
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  add(path_568352, "largeFaceListId", newJString(largeFaceListId))
  add(query_568353, "top", newJInt(top))
  add(query_568353, "start", newJString(start))
  result = call_568351.call(path_568352, query_568353, nil, nil, nil)

var largeFaceListListFaces* = Call_LargeFaceListListFaces_568344(
    name: "largeFaceListListFaces", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/persistedfaces",
    validator: validate_LargeFaceListListFaces_568345, base: "",
    url: url_LargeFaceListListFaces_568346, schemes: {Scheme.Https})
type
  Call_LargeFaceListGetFace_568367 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListGetFace_568369(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListGetFace_568368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a persisted face (specified by persistedFaceId and its belonging largeFaceListId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568370 = path.getOrDefault("largeFaceListId")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "largeFaceListId", valid_568370
  var valid_568371 = path.getOrDefault("persistedFaceId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "persistedFaceId", valid_568371
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_LargeFaceListGetFace_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId and its belonging largeFaceListId).
  ## 
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_LargeFaceListGetFace_568367; largeFaceListId: string;
          persistedFaceId: string): Recallable =
  ## largeFaceListGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId and its belonging largeFaceListId).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  var path_568374 = newJObject()
  add(path_568374, "largeFaceListId", newJString(largeFaceListId))
  add(path_568374, "persistedFaceId", newJString(persistedFaceId))
  result = call_568373.call(path_568374, nil, nil, nil, nil)

var largeFaceListGetFace* = Call_LargeFaceListGetFace_568367(
    name: "largeFaceListGetFace", meth: HttpMethod.HttpGet, host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListGetFace_568368, base: "",
    url: url_LargeFaceListGetFace_568369, schemes: {Scheme.Https})
type
  Call_LargeFaceListUpdateFace_568383 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListUpdateFace_568385(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListUpdateFace_568384(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a persisted face's userData field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568386 = path.getOrDefault("largeFaceListId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "largeFaceListId", valid_568386
  var valid_568387 = path.getOrDefault("persistedFaceId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "persistedFaceId", valid_568387
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_LargeFaceListUpdateFace_568383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a persisted face's userData field.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_LargeFaceListUpdateFace_568383;
          largeFaceListId: string; persistedFaceId: string; body: JsonNode): Recallable =
  ## largeFaceListUpdateFace
  ## Update a persisted face's userData field.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  var path_568391 = newJObject()
  var body_568392 = newJObject()
  add(path_568391, "largeFaceListId", newJString(largeFaceListId))
  add(path_568391, "persistedFaceId", newJString(persistedFaceId))
  if body != nil:
    body_568392 = body
  result = call_568390.call(path_568391, nil, nil, nil, body_568392)

var largeFaceListUpdateFace* = Call_LargeFaceListUpdateFace_568383(
    name: "largeFaceListUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListUpdateFace_568384, base: "",
    url: url_LargeFaceListUpdateFace_568385, schemes: {Scheme.Https})
type
  Call_LargeFaceListDeleteFace_568375 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListDeleteFace_568377(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListDeleteFace_568376(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a face from a large face list by specified largeFaceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same large face list are processed sequentially and to/from different large face lists are in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568378 = path.getOrDefault("largeFaceListId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "largeFaceListId", valid_568378
  var valid_568379 = path.getOrDefault("persistedFaceId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "persistedFaceId", valid_568379
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_LargeFaceListDeleteFace_568375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a large face list by specified largeFaceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same large face list are processed sequentially and to/from different large face lists are in parallel.
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_LargeFaceListDeleteFace_568375;
          largeFaceListId: string; persistedFaceId: string): Recallable =
  ## largeFaceListDeleteFace
  ## Delete a face from a large face list by specified largeFaceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same large face list are processed sequentially and to/from different large face lists are in parallel.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  var path_568382 = newJObject()
  add(path_568382, "largeFaceListId", newJString(largeFaceListId))
  add(path_568382, "persistedFaceId", newJString(persistedFaceId))
  result = call_568381.call(path_568382, nil, nil, nil, nil)

var largeFaceListDeleteFace* = Call_LargeFaceListDeleteFace_568375(
    name: "largeFaceListDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListDeleteFace_568376, base: "",
    url: url_LargeFaceListDeleteFace_568377, schemes: {Scheme.Https})
type
  Call_LargeFaceListTrain_568393 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListTrain_568395(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListTrain_568394(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Queue a large face list training task, the training task may not be started immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568396 = path.getOrDefault("largeFaceListId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "largeFaceListId", valid_568396
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568397: Call_LargeFaceListTrain_568393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a large face list training task, the training task may not be started immediately.
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_LargeFaceListTrain_568393; largeFaceListId: string): Recallable =
  ## largeFaceListTrain
  ## Queue a large face list training task, the training task may not be started immediately.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_568399 = newJObject()
  add(path_568399, "largeFaceListId", newJString(largeFaceListId))
  result = call_568398.call(path_568399, nil, nil, nil, nil)

var largeFaceListTrain* = Call_LargeFaceListTrain_568393(
    name: "largeFaceListTrain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/train",
    validator: validate_LargeFaceListTrain_568394, base: "",
    url: url_LargeFaceListTrain_568395, schemes: {Scheme.Https})
type
  Call_LargeFaceListGetTrainingStatus_568400 = ref object of OpenApiRestCall_567668
proc url_LargeFaceListGetTrainingStatus_568402(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/training")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListGetTrainingStatus_568401(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the training status of a large face list (completed or ongoing).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_568403 = path.getOrDefault("largeFaceListId")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "largeFaceListId", valid_568403
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_LargeFaceListGetTrainingStatus_568400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the training status of a large face list (completed or ongoing).
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_LargeFaceListGetTrainingStatus_568400;
          largeFaceListId: string): Recallable =
  ## largeFaceListGetTrainingStatus
  ## Retrieve the training status of a large face list (completed or ongoing).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_568406 = newJObject()
  add(path_568406, "largeFaceListId", newJString(largeFaceListId))
  result = call_568405.call(path_568406, nil, nil, nil, nil)

var largeFaceListGetTrainingStatus* = Call_LargeFaceListGetTrainingStatus_568400(
    name: "largeFaceListGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/training",
    validator: validate_LargeFaceListGetTrainingStatus_568401, base: "",
    url: url_LargeFaceListGetTrainingStatus_568402, schemes: {Scheme.Https})
type
  Call_LargePersonGroupList_568407 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupList_568409(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LargePersonGroupList_568408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all existing large person groups’ largePersonGroupId, name, userData and recognitionModel.<br />
  ## * Large person groups are stored in alphabetical order of largePersonGroupId.
  ## * "start" parameter (string, optional) is a user-provided largePersonGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : The number of large person groups to list.
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: JString
  ##        : List large person groups from the least largePersonGroupId greater than the "start".
  section = newJObject()
  var valid_568411 = query.getOrDefault("top")
  valid_568411 = validateParameter(valid_568411, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568411 != nil:
    section.add "top", valid_568411
  var valid_568412 = query.getOrDefault("returnRecognitionModel")
  valid_568412 = validateParameter(valid_568412, JBool, required = false,
                                 default = newJBool(false))
  if valid_568412 != nil:
    section.add "returnRecognitionModel", valid_568412
  var valid_568413 = query.getOrDefault("start")
  valid_568413 = validateParameter(valid_568413, JString, required = false,
                                 default = nil)
  if valid_568413 != nil:
    section.add "start", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_LargePersonGroupList_568407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all existing large person groups’ largePersonGroupId, name, userData and recognitionModel.<br />
  ## * Large person groups are stored in alphabetical order of largePersonGroupId.
  ## * "start" parameter (string, optional) is a user-provided largePersonGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_LargePersonGroupList_568407; top: int = 1000;
          returnRecognitionModel: bool = false; start: string = ""): Recallable =
  ## largePersonGroupList
  ## List all existing large person groups’ largePersonGroupId, name, userData and recognitionModel.<br />
  ## * Large person groups are stored in alphabetical order of largePersonGroupId.
  ## * "start" parameter (string, optional) is a user-provided largePersonGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ##   top: int
  ##      : The number of large person groups to list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: string
  ##        : List large person groups from the least largePersonGroupId greater than the "start".
  var query_568416 = newJObject()
  add(query_568416, "top", newJInt(top))
  add(query_568416, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_568416, "start", newJString(start))
  result = call_568415.call(nil, query_568416, nil, nil, nil)

var largePersonGroupList* = Call_LargePersonGroupList_568407(
    name: "largePersonGroupList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largepersongroups", validator: validate_LargePersonGroupList_568408,
    base: "", url: url_LargePersonGroupList_568409, schemes: {Scheme.Https})
type
  Call_LargePersonGroupCreate_568426 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupCreate_568428(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupCreate_568427(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new large person group with user-specified largePersonGroupId, name, an optional userData and recognitionModel.
  ## <br /> A large person group is the container of the uploaded person data, including face recognition feature, and up to 1,000,000
  ## people.
  ## <br /> After creation, use [LargePersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/599adcba3a7b9412a4d53f40) to add person into the group, and call [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br/>'recognitionModel' should be specified to associate with this large person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large person group will use the recognition model that's already associated with the collection. Existing face features in a large person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargePersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d). All those large person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large person group quota:
  ## * Free-tier subscription quota: 1,000 large person groups.
  ## * S0-tier subscription quota: 1,000,000 large person groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_568429 = path.getOrDefault("largePersonGroupId")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "largePersonGroupId", valid_568429
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating new large person group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568431: Call_LargePersonGroupCreate_568426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new large person group with user-specified largePersonGroupId, name, an optional userData and recognitionModel.
  ## <br /> A large person group is the container of the uploaded person data, including face recognition feature, and up to 1,000,000
  ## people.
  ## <br /> After creation, use [LargePersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/599adcba3a7b9412a4d53f40) to add person into the group, and call [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br/>'recognitionModel' should be specified to associate with this large person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large person group will use the recognition model that's already associated with the collection. Existing face features in a large person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargePersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d). All those large person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large person group quota:
  ## * Free-tier subscription quota: 1,000 large person groups.
  ## * S0-tier subscription quota: 1,000,000 large person groups.
  ## 
  let valid = call_568431.validator(path, query, header, formData, body)
  let scheme = call_568431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568431.url(scheme.get, call_568431.host, call_568431.base,
                         call_568431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568431, url, valid)

proc call*(call_568432: Call_LargePersonGroupCreate_568426;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupCreate
  ## Create a new large person group with user-specified largePersonGroupId, name, an optional userData and recognitionModel.
  ## <br /> A large person group is the container of the uploaded person data, including face recognition feature, and up to 1,000,000
  ## people.
  ## <br /> After creation, use [LargePersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/599adcba3a7b9412a4d53f40) to add person into the group, and call [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br/>'recognitionModel' should be specified to associate with this large person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large person group will use the recognition model that's already associated with the collection. Existing face features in a large person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargePersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d). All those large person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large person group quota:
  ## * Free-tier subscription quota: 1,000 large person groups.
  ## * S0-tier subscription quota: 1,000,000 large person groups.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for creating new large person group.
  var path_568433 = newJObject()
  var body_568434 = newJObject()
  add(path_568433, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_568434 = body
  result = call_568432.call(path_568433, nil, nil, nil, body_568434)

var largePersonGroupCreate* = Call_LargePersonGroupCreate_568426(
    name: "largePersonGroupCreate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupCreate_568427, base: "",
    url: url_LargePersonGroupCreate_568428, schemes: {Scheme.Https})
type
  Call_LargePersonGroupGet_568417 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupGet_568419(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupGet_568418(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve the information of a large person group, including its name, userData and recognitionModel. This API returns large person group information only, use [LargePersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/599adda06ac60f11b48b5aa1) instead to retrieve person information under the large person group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_568420 = path.getOrDefault("largePersonGroupId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "largePersonGroupId", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_568421 = query.getOrDefault("returnRecognitionModel")
  valid_568421 = validateParameter(valid_568421, JBool, required = false,
                                 default = newJBool(false))
  if valid_568421 != nil:
    section.add "returnRecognitionModel", valid_568421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568422: Call_LargePersonGroupGet_568417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the information of a large person group, including its name, userData and recognitionModel. This API returns large person group information only, use [LargePersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/599adda06ac60f11b48b5aa1) instead to retrieve person information under the large person group.
  ## 
  ## 
  let valid = call_568422.validator(path, query, header, formData, body)
  let scheme = call_568422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568422.url(scheme.get, call_568422.host, call_568422.base,
                         call_568422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568422, url, valid)

proc call*(call_568423: Call_LargePersonGroupGet_568417;
          largePersonGroupId: string; returnRecognitionModel: bool = false): Recallable =
  ## largePersonGroupGet
  ## Retrieve the information of a large person group, including its name, userData and recognitionModel. This API returns large person group information only, use [LargePersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/599adda06ac60f11b48b5aa1) instead to retrieve person information under the large person group.
  ## 
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_568424 = newJObject()
  var query_568425 = newJObject()
  add(path_568424, "largePersonGroupId", newJString(largePersonGroupId))
  add(query_568425, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_568423.call(path_568424, query_568425, nil, nil, nil)

var largePersonGroupGet* = Call_LargePersonGroupGet_568417(
    name: "largePersonGroupGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupGet_568418, base: "",
    url: url_LargePersonGroupGet_568419, schemes: {Scheme.Https})
type
  Call_LargePersonGroupUpdate_568442 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupUpdate_568444(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupUpdate_568443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing large person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_568445 = path.getOrDefault("largePersonGroupId")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "largePersonGroupId", valid_568445
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating large person group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_LargePersonGroupUpdate_568442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing large person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_LargePersonGroupUpdate_568442;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupUpdate
  ## Update an existing large person group's display name and userData. The properties which does not appear in request body will not be updated.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for updating large person group.
  var path_568449 = newJObject()
  var body_568450 = newJObject()
  add(path_568449, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_568450 = body
  result = call_568448.call(path_568449, nil, nil, nil, body_568450)

var largePersonGroupUpdate* = Call_LargePersonGroupUpdate_568442(
    name: "largePersonGroupUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupUpdate_568443, base: "",
    url: url_LargePersonGroupUpdate_568444, schemes: {Scheme.Https})
type
  Call_LargePersonGroupDelete_568435 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupDelete_568437(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupDelete_568436(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing large person group. Persisted face features of all people in the large person group will also be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_568438 = path.getOrDefault("largePersonGroupId")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "largePersonGroupId", valid_568438
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_LargePersonGroupDelete_568435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing large person group. Persisted face features of all people in the large person group will also be deleted.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_LargePersonGroupDelete_568435;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupDelete
  ## Delete an existing large person group. Persisted face features of all people in the large person group will also be deleted.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_568441 = newJObject()
  add(path_568441, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_568440.call(path_568441, nil, nil, nil, nil)

var largePersonGroupDelete* = Call_LargePersonGroupDelete_568435(
    name: "largePersonGroupDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupDelete_568436, base: "",
    url: url_LargePersonGroupDelete_568437, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonCreate_568461 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonCreate_568463(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonCreate_568462(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new person in a specified large person group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_568464 = path.getOrDefault("largePersonGroupId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "largePersonGroupId", valid_568464
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568466: Call_LargePersonGroupPersonCreate_568461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new person in a specified large person group.
  ## 
  let valid = call_568466.validator(path, query, header, formData, body)
  let scheme = call_568466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568466.url(scheme.get, call_568466.host, call_568466.base,
                         call_568466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568466, url, valid)

proc call*(call_568467: Call_LargePersonGroupPersonCreate_568461;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupPersonCreate
  ## Create a new person in a specified large person group.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  var path_568468 = newJObject()
  var body_568469 = newJObject()
  add(path_568468, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_568469 = body
  result = call_568467.call(path_568468, nil, nil, nil, body_568469)

var largePersonGroupPersonCreate* = Call_LargePersonGroupPersonCreate_568461(
    name: "largePersonGroupPersonCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons",
    validator: validate_LargePersonGroupPersonCreate_568462, base: "",
    url: url_LargePersonGroupPersonCreate_568463, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonList_568451 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonList_568453(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonList_568452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all persons in a large person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_568454 = path.getOrDefault("largePersonGroupId")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "largePersonGroupId", valid_568454
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   start: JString
  ##        : Starting person id to return (used to list a range of persons).
  section = newJObject()
  var valid_568455 = query.getOrDefault("top")
  valid_568455 = validateParameter(valid_568455, JInt, required = false, default = nil)
  if valid_568455 != nil:
    section.add "top", valid_568455
  var valid_568456 = query.getOrDefault("start")
  valid_568456 = validateParameter(valid_568456, JString, required = false,
                                 default = nil)
  if valid_568456 != nil:
    section.add "start", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568457: Call_LargePersonGroupPersonList_568451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all persons in a large person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  let valid = call_568457.validator(path, query, header, formData, body)
  let scheme = call_568457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568457.url(scheme.get, call_568457.host, call_568457.base,
                         call_568457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568457, url, valid)

proc call*(call_568458: Call_LargePersonGroupPersonList_568451;
          largePersonGroupId: string; top: int = 0; start: string = ""): Recallable =
  ## largePersonGroupPersonList
  ## List all persons in a large person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ##   top: int
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   start: string
  ##        : Starting person id to return (used to list a range of persons).
  var path_568459 = newJObject()
  var query_568460 = newJObject()
  add(query_568460, "top", newJInt(top))
  add(path_568459, "largePersonGroupId", newJString(largePersonGroupId))
  add(query_568460, "start", newJString(start))
  result = call_568458.call(path_568459, query_568460, nil, nil, nil)

var largePersonGroupPersonList* = Call_LargePersonGroupPersonList_568451(
    name: "largePersonGroupPersonList", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons",
    validator: validate_LargePersonGroupPersonList_568452, base: "",
    url: url_LargePersonGroupPersonList_568453, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonGet_568470 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonGet_568472(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonGet_568471(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_568473 = path.getOrDefault("personId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "personId", valid_568473
  var valid_568474 = path.getOrDefault("largePersonGroupId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "largePersonGroupId", valid_568474
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568475: Call_LargePersonGroupPersonGet_568470; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ## 
  let valid = call_568475.validator(path, query, header, formData, body)
  let scheme = call_568475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568475.url(scheme.get, call_568475.host, call_568475.base,
                         call_568475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568475, url, valid)

proc call*(call_568476: Call_LargePersonGroupPersonGet_568470; personId: string;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupPersonGet
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_568477 = newJObject()
  add(path_568477, "personId", newJString(personId))
  add(path_568477, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_568476.call(path_568477, nil, nil, nil, nil)

var largePersonGroupPersonGet* = Call_LargePersonGroupPersonGet_568470(
    name: "largePersonGroupPersonGet", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonGet_568471, base: "",
    url: url_LargePersonGroupPersonGet_568472, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonUpdate_568486 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonUpdate_568488(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonUpdate_568487(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update name or userData of a person.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_568489 = path.getOrDefault("personId")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "personId", valid_568489
  var valid_568490 = path.getOrDefault("largePersonGroupId")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "largePersonGroupId", valid_568490
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568492: Call_LargePersonGroupPersonUpdate_568486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update name or userData of a person.
  ## 
  let valid = call_568492.validator(path, query, header, formData, body)
  let scheme = call_568492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568492.url(scheme.get, call_568492.host, call_568492.base,
                         call_568492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568492, url, valid)

proc call*(call_568493: Call_LargePersonGroupPersonUpdate_568486; personId: string;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupPersonUpdate
  ## Update name or userData of a person.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  var path_568494 = newJObject()
  var body_568495 = newJObject()
  add(path_568494, "personId", newJString(personId))
  add(path_568494, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_568495 = body
  result = call_568493.call(path_568494, nil, nil, nil, body_568495)

var largePersonGroupPersonUpdate* = Call_LargePersonGroupPersonUpdate_568486(
    name: "largePersonGroupPersonUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonUpdate_568487, base: "",
    url: url_LargePersonGroupPersonUpdate_568488, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonDelete_568478 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonDelete_568480(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonDelete_568479(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_568481 = path.getOrDefault("personId")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "personId", valid_568481
  var valid_568482 = path.getOrDefault("largePersonGroupId")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "largePersonGroupId", valid_568482
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568483: Call_LargePersonGroupPersonDelete_568478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  let valid = call_568483.validator(path, query, header, formData, body)
  let scheme = call_568483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568483.url(scheme.get, call_568483.host, call_568483.base,
                         call_568483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568483, url, valid)

proc call*(call_568484: Call_LargePersonGroupPersonDelete_568478; personId: string;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupPersonDelete
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_568485 = newJObject()
  add(path_568485, "personId", newJString(personId))
  add(path_568485, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_568484.call(path_568485, nil, nil, nil, nil)

var largePersonGroupPersonDelete* = Call_LargePersonGroupPersonDelete_568478(
    name: "largePersonGroupPersonDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonDelete_568479, base: "",
    url: url_LargePersonGroupPersonDelete_568480, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonAddFaceFromUrl_568496 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonAddFaceFromUrl_568498(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonAddFaceFromUrl_568497(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a person into a large person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargePersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ae2966ac60f11b48b5aa3), [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargePersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/599adf2a3a7b9412a4d53f42). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_568499 = path.getOrDefault("personId")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "personId", valid_568499
  var valid_568500 = path.getOrDefault("largePersonGroupId")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "largePersonGroupId", valid_568500
  result.add "path", section
  ## parameters in `query` object:
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  section = newJObject()
  var valid_568501 = query.getOrDefault("userData")
  valid_568501 = validateParameter(valid_568501, JString, required = false,
                                 default = nil)
  if valid_568501 != nil:
    section.add "userData", valid_568501
  var valid_568502 = query.getOrDefault("detectionModel")
  valid_568502 = validateParameter(valid_568502, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_568502 != nil:
    section.add "detectionModel", valid_568502
  var valid_568503 = query.getOrDefault("targetFace")
  valid_568503 = validateParameter(valid_568503, JArray, required = false,
                                 default = nil)
  if valid_568503 != nil:
    section.add "targetFace", valid_568503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568505: Call_LargePersonGroupPersonAddFaceFromUrl_568496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a face to a person into a large person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargePersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ae2966ac60f11b48b5aa3), [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargePersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/599adf2a3a7b9412a4d53f42). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  let valid = call_568505.validator(path, query, header, formData, body)
  let scheme = call_568505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568505.url(scheme.get, call_568505.host, call_568505.base,
                         call_568505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568505, url, valid)

proc call*(call_568506: Call_LargePersonGroupPersonAddFaceFromUrl_568496;
          personId: string; ImageUrl: JsonNode; largePersonGroupId: string;
          userData: string = ""; detectionModel: string = "detection_01";
          targetFace: JsonNode = nil): Recallable =
  ## largePersonGroupPersonAddFaceFromUrl
  ## Add a face to a person into a large person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargePersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ae2966ac60f11b48b5aa3), [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargePersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/599adf2a3a7b9412a4d53f42). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  var path_568507 = newJObject()
  var query_568508 = newJObject()
  var body_568509 = newJObject()
  add(path_568507, "personId", newJString(personId))
  add(query_568508, "userData", newJString(userData))
  if ImageUrl != nil:
    body_568509 = ImageUrl
  add(query_568508, "detectionModel", newJString(detectionModel))
  add(path_568507, "largePersonGroupId", newJString(largePersonGroupId))
  if targetFace != nil:
    query_568508.add "targetFace", targetFace
  result = call_568506.call(path_568507, query_568508, nil, nil, body_568509)

var largePersonGroupPersonAddFaceFromUrl* = Call_LargePersonGroupPersonAddFaceFromUrl_568496(
    name: "largePersonGroupPersonAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces",
    validator: validate_LargePersonGroupPersonAddFaceFromUrl_568497, base: "",
    url: url_LargePersonGroupPersonAddFaceFromUrl_568498, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonGetFace_568510 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonGetFace_568512(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonGetFace_568511(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_568513 = path.getOrDefault("persistedFaceId")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "persistedFaceId", valid_568513
  var valid_568514 = path.getOrDefault("personId")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "personId", valid_568514
  var valid_568515 = path.getOrDefault("largePersonGroupId")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "largePersonGroupId", valid_568515
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568516: Call_LargePersonGroupPersonGetFace_568510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ## 
  let valid = call_568516.validator(path, query, header, formData, body)
  let scheme = call_568516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568516.url(scheme.get, call_568516.host, call_568516.base,
                         call_568516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568516, url, valid)

proc call*(call_568517: Call_LargePersonGroupPersonGetFace_568510;
          persistedFaceId: string; personId: string; largePersonGroupId: string): Recallable =
  ## largePersonGroupPersonGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_568518 = newJObject()
  add(path_568518, "persistedFaceId", newJString(persistedFaceId))
  add(path_568518, "personId", newJString(personId))
  add(path_568518, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_568517.call(path_568518, nil, nil, nil, nil)

var largePersonGroupPersonGetFace* = Call_LargePersonGroupPersonGetFace_568510(
    name: "largePersonGroupPersonGetFace", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonGetFace_568511, base: "",
    url: url_LargePersonGroupPersonGetFace_568512, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonUpdateFace_568528 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonUpdateFace_568530(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonUpdateFace_568529(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a person persisted face's userData field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_568531 = path.getOrDefault("persistedFaceId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "persistedFaceId", valid_568531
  var valid_568532 = path.getOrDefault("personId")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "personId", valid_568532
  var valid_568533 = path.getOrDefault("largePersonGroupId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "largePersonGroupId", valid_568533
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568535: Call_LargePersonGroupPersonUpdateFace_568528;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a person persisted face's userData field.
  ## 
  let valid = call_568535.validator(path, query, header, formData, body)
  let scheme = call_568535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568535.url(scheme.get, call_568535.host, call_568535.base,
                         call_568535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568535, url, valid)

proc call*(call_568536: Call_LargePersonGroupPersonUpdateFace_568528;
          persistedFaceId: string; personId: string; largePersonGroupId: string;
          body: JsonNode): Recallable =
  ## largePersonGroupPersonUpdateFace
  ## Update a person persisted face's userData field.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  var path_568537 = newJObject()
  var body_568538 = newJObject()
  add(path_568537, "persistedFaceId", newJString(persistedFaceId))
  add(path_568537, "personId", newJString(personId))
  add(path_568537, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_568538 = body
  result = call_568536.call(path_568537, nil, nil, nil, body_568538)

var largePersonGroupPersonUpdateFace* = Call_LargePersonGroupPersonUpdateFace_568528(
    name: "largePersonGroupPersonUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonUpdateFace_568529, base: "",
    url: url_LargePersonGroupPersonUpdateFace_568530, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonDeleteFace_568519 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupPersonDeleteFace_568521(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonDeleteFace_568520(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_568522 = path.getOrDefault("persistedFaceId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "persistedFaceId", valid_568522
  var valid_568523 = path.getOrDefault("personId")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "personId", valid_568523
  var valid_568524 = path.getOrDefault("largePersonGroupId")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "largePersonGroupId", valid_568524
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_LargePersonGroupPersonDeleteFace_568519;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_LargePersonGroupPersonDeleteFace_568519;
          persistedFaceId: string; personId: string; largePersonGroupId: string): Recallable =
  ## largePersonGroupPersonDeleteFace
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_568527 = newJObject()
  add(path_568527, "persistedFaceId", newJString(persistedFaceId))
  add(path_568527, "personId", newJString(personId))
  add(path_568527, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_568526.call(path_568527, nil, nil, nil, nil)

var largePersonGroupPersonDeleteFace* = Call_LargePersonGroupPersonDeleteFace_568519(
    name: "largePersonGroupPersonDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonDeleteFace_568520, base: "",
    url: url_LargePersonGroupPersonDeleteFace_568521, schemes: {Scheme.Https})
type
  Call_LargePersonGroupTrain_568539 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupTrain_568541(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupTrain_568540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queue a large person group training task, the training task may not be started immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_568542 = path.getOrDefault("largePersonGroupId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "largePersonGroupId", valid_568542
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568543: Call_LargePersonGroupTrain_568539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a large person group training task, the training task may not be started immediately.
  ## 
  let valid = call_568543.validator(path, query, header, formData, body)
  let scheme = call_568543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568543.url(scheme.get, call_568543.host, call_568543.base,
                         call_568543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568543, url, valid)

proc call*(call_568544: Call_LargePersonGroupTrain_568539;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupTrain
  ## Queue a large person group training task, the training task may not be started immediately.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_568545 = newJObject()
  add(path_568545, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_568544.call(path_568545, nil, nil, nil, nil)

var largePersonGroupTrain* = Call_LargePersonGroupTrain_568539(
    name: "largePersonGroupTrain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/train",
    validator: validate_LargePersonGroupTrain_568540, base: "",
    url: url_LargePersonGroupTrain_568541, schemes: {Scheme.Https})
type
  Call_LargePersonGroupGetTrainingStatus_568546 = ref object of OpenApiRestCall_567668
proc url_LargePersonGroupGetTrainingStatus_568548(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/training")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupGetTrainingStatus_568547(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the training status of a large person group (completed or ongoing).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_568549 = path.getOrDefault("largePersonGroupId")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "largePersonGroupId", valid_568549
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568550: Call_LargePersonGroupGetTrainingStatus_568546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the training status of a large person group (completed or ongoing).
  ## 
  let valid = call_568550.validator(path, query, header, formData, body)
  let scheme = call_568550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568550.url(scheme.get, call_568550.host, call_568550.base,
                         call_568550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568550, url, valid)

proc call*(call_568551: Call_LargePersonGroupGetTrainingStatus_568546;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupGetTrainingStatus
  ## Retrieve the training status of a large person group (completed or ongoing).
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_568552 = newJObject()
  add(path_568552, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_568551.call(path_568552, nil, nil, nil, nil)

var largePersonGroupGetTrainingStatus* = Call_LargePersonGroupGetTrainingStatus_568546(
    name: "largePersonGroupGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/training",
    validator: validate_LargePersonGroupGetTrainingStatus_568547, base: "",
    url: url_LargePersonGroupGetTrainingStatus_568548, schemes: {Scheme.Https})
type
  Call_SnapshotGetOperationStatus_568553 = ref object of OpenApiRestCall_567668
proc url_SnapshotGetOperationStatus_568555(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotGetOperationStatus_568554(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the status of a take/apply snapshot operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Id referencing a particular take/apply snapshot operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_568556 = path.getOrDefault("operationId")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "operationId", valid_568556
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568557: Call_SnapshotGetOperationStatus_568553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the status of a take/apply snapshot operation.
  ## 
  let valid = call_568557.validator(path, query, header, formData, body)
  let scheme = call_568557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568557.url(scheme.get, call_568557.host, call_568557.base,
                         call_568557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568557, url, valid)

proc call*(call_568558: Call_SnapshotGetOperationStatus_568553; operationId: string): Recallable =
  ## snapshotGetOperationStatus
  ## Retrieve the status of a take/apply snapshot operation.
  ##   operationId: string (required)
  ##              : Id referencing a particular take/apply snapshot operation.
  var path_568559 = newJObject()
  add(path_568559, "operationId", newJString(operationId))
  result = call_568558.call(path_568559, nil, nil, nil, nil)

var snapshotGetOperationStatus* = Call_SnapshotGetOperationStatus_568553(
    name: "snapshotGetOperationStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/operations/{operationId}",
    validator: validate_SnapshotGetOperationStatus_568554, base: "",
    url: url_SnapshotGetOperationStatus_568555, schemes: {Scheme.Https})
type
  Call_PersonGroupList_568560 = ref object of OpenApiRestCall_567668
proc url_PersonGroupList_568562(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PersonGroupList_568561(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List person groups’ personGroupId, name, userData and recognitionModel.<br />
  ## * Person groups are stored in alphabetical order of personGroupId.
  ## * "start" parameter (string, optional) is a user-provided personGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : The number of person groups to list.
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: JString
  ##        : List person groups from the least personGroupId greater than the "start".
  section = newJObject()
  var valid_568563 = query.getOrDefault("top")
  valid_568563 = validateParameter(valid_568563, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568563 != nil:
    section.add "top", valid_568563
  var valid_568564 = query.getOrDefault("returnRecognitionModel")
  valid_568564 = validateParameter(valid_568564, JBool, required = false,
                                 default = newJBool(false))
  if valid_568564 != nil:
    section.add "returnRecognitionModel", valid_568564
  var valid_568565 = query.getOrDefault("start")
  valid_568565 = validateParameter(valid_568565, JString, required = false,
                                 default = nil)
  if valid_568565 != nil:
    section.add "start", valid_568565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568566: Call_PersonGroupList_568560; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List person groups’ personGroupId, name, userData and recognitionModel.<br />
  ## * Person groups are stored in alphabetical order of personGroupId.
  ## * "start" parameter (string, optional) is a user-provided personGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ## 
  let valid = call_568566.validator(path, query, header, formData, body)
  let scheme = call_568566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568566.url(scheme.get, call_568566.host, call_568566.base,
                         call_568566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568566, url, valid)

proc call*(call_568567: Call_PersonGroupList_568560; top: int = 1000;
          returnRecognitionModel: bool = false; start: string = ""): Recallable =
  ## personGroupList
  ## List person groups’ personGroupId, name, userData and recognitionModel.<br />
  ## * Person groups are stored in alphabetical order of personGroupId.
  ## * "start" parameter (string, optional) is a user-provided personGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ##   top: int
  ##      : The number of person groups to list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: string
  ##        : List person groups from the least personGroupId greater than the "start".
  var query_568568 = newJObject()
  add(query_568568, "top", newJInt(top))
  add(query_568568, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_568568, "start", newJString(start))
  result = call_568567.call(nil, query_568568, nil, nil, nil)

var personGroupList* = Call_PersonGroupList_568560(name: "personGroupList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/persongroups",
    validator: validate_PersonGroupList_568561, base: "", url: url_PersonGroupList_568562,
    schemes: {Scheme.Https})
type
  Call_PersonGroupCreate_568578 = ref object of OpenApiRestCall_567668
proc url_PersonGroupCreate_568580(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupCreate_568579(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a new person group with specified personGroupId, name, user-provided userData and recognitionModel.
  ## <br /> A person group is the container of the uploaded person data, including face recognition features.
  ## <br /> After creation, use [PersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523c) to add persons into the group, and then call [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br/>'recognitionModel' should be specified to associate with this person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing person group will use the recognition model that's already associated with the collection. Existing face features in a person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [PersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244). All those person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Person group quota:
  ## * Free-tier subscription quota: 1,000 person groups. Each holds up to 1,000 persons.
  ## * S0-tier subscription quota: 1,000,000 person groups. Each holds up to 10,000 persons.
  ## * to handle larger scale face identification problem, please consider using [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568581 = path.getOrDefault("personGroupId")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "personGroupId", valid_568581
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating new person group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568583: Call_PersonGroupCreate_568578; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new person group with specified personGroupId, name, user-provided userData and recognitionModel.
  ## <br /> A person group is the container of the uploaded person data, including face recognition features.
  ## <br /> After creation, use [PersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523c) to add persons into the group, and then call [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br/>'recognitionModel' should be specified to associate with this person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing person group will use the recognition model that's already associated with the collection. Existing face features in a person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [PersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244). All those person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Person group quota:
  ## * Free-tier subscription quota: 1,000 person groups. Each holds up to 1,000 persons.
  ## * S0-tier subscription quota: 1,000,000 person groups. Each holds up to 10,000 persons.
  ## * to handle larger scale face identification problem, please consider using [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d).
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_PersonGroupCreate_568578; personGroupId: string;
          body: JsonNode): Recallable =
  ## personGroupCreate
  ## Create a new person group with specified personGroupId, name, user-provided userData and recognitionModel.
  ## <br /> A person group is the container of the uploaded person data, including face recognition features.
  ## <br /> After creation, use [PersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523c) to add persons into the group, and then call [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br/>'recognitionModel' should be specified to associate with this person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing person group will use the recognition model that's already associated with the collection. Existing face features in a person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [PersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244). All those person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Person group quota:
  ## * Free-tier subscription quota: 1,000 person groups. Each holds up to 1,000 persons.
  ## * S0-tier subscription quota: 1,000,000 person groups. Each holds up to 10,000 persons.
  ## * to handle larger scale face identification problem, please consider using [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   body: JObject (required)
  ##       : Request body for creating new person group.
  var path_568585 = newJObject()
  var body_568586 = newJObject()
  add(path_568585, "personGroupId", newJString(personGroupId))
  if body != nil:
    body_568586 = body
  result = call_568584.call(path_568585, nil, nil, nil, body_568586)

var personGroupCreate* = Call_PersonGroupCreate_568578(name: "personGroupCreate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupCreate_568579,
    base: "", url: url_PersonGroupCreate_568580, schemes: {Scheme.Https})
type
  Call_PersonGroupGet_568569 = ref object of OpenApiRestCall_567668
proc url_PersonGroupGet_568571(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupGet_568570(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieve person group name, userData and recognitionModel. To get person information under this personGroup, use [PersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395241).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568572 = path.getOrDefault("personGroupId")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "personGroupId", valid_568572
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_568573 = query.getOrDefault("returnRecognitionModel")
  valid_568573 = validateParameter(valid_568573, JBool, required = false,
                                 default = newJBool(false))
  if valid_568573 != nil:
    section.add "returnRecognitionModel", valid_568573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568574: Call_PersonGroupGet_568569; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve person group name, userData and recognitionModel. To get person information under this personGroup, use [PersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395241).
  ## 
  let valid = call_568574.validator(path, query, header, formData, body)
  let scheme = call_568574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568574.url(scheme.get, call_568574.host, call_568574.base,
                         call_568574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568574, url, valid)

proc call*(call_568575: Call_PersonGroupGet_568569; personGroupId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## personGroupGet
  ## Retrieve person group name, userData and recognitionModel. To get person information under this personGroup, use [PersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395241).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_568576 = newJObject()
  var query_568577 = newJObject()
  add(path_568576, "personGroupId", newJString(personGroupId))
  add(query_568577, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_568575.call(path_568576, query_568577, nil, nil, nil)

var personGroupGet* = Call_PersonGroupGet_568569(name: "personGroupGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupGet_568570,
    base: "", url: url_PersonGroupGet_568571, schemes: {Scheme.Https})
type
  Call_PersonGroupUpdate_568594 = ref object of OpenApiRestCall_567668
proc url_PersonGroupUpdate_568596(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupUpdate_568595(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update an existing person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568597 = path.getOrDefault("personGroupId")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "personGroupId", valid_568597
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating person group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568599: Call_PersonGroupUpdate_568594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  let valid = call_568599.validator(path, query, header, formData, body)
  let scheme = call_568599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568599.url(scheme.get, call_568599.host, call_568599.base,
                         call_568599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568599, url, valid)

proc call*(call_568600: Call_PersonGroupUpdate_568594; personGroupId: string;
          body: JsonNode): Recallable =
  ## personGroupUpdate
  ## Update an existing person group's display name and userData. The properties which does not appear in request body will not be updated.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   body: JObject (required)
  ##       : Request body for updating person group.
  var path_568601 = newJObject()
  var body_568602 = newJObject()
  add(path_568601, "personGroupId", newJString(personGroupId))
  if body != nil:
    body_568602 = body
  result = call_568600.call(path_568601, nil, nil, nil, body_568602)

var personGroupUpdate* = Call_PersonGroupUpdate_568594(name: "personGroupUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupUpdate_568595,
    base: "", url: url_PersonGroupUpdate_568596, schemes: {Scheme.Https})
type
  Call_PersonGroupDelete_568587 = ref object of OpenApiRestCall_567668
proc url_PersonGroupDelete_568589(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupDelete_568588(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an existing person group. Persisted face features of all people in the person group will also be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568590 = path.getOrDefault("personGroupId")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "personGroupId", valid_568590
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568591: Call_PersonGroupDelete_568587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person group. Persisted face features of all people in the person group will also be deleted.
  ## 
  let valid = call_568591.validator(path, query, header, formData, body)
  let scheme = call_568591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568591.url(scheme.get, call_568591.host, call_568591.base,
                         call_568591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568591, url, valid)

proc call*(call_568592: Call_PersonGroupDelete_568587; personGroupId: string): Recallable =
  ## personGroupDelete
  ## Delete an existing person group. Persisted face features of all people in the person group will also be deleted.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_568593 = newJObject()
  add(path_568593, "personGroupId", newJString(personGroupId))
  result = call_568592.call(path_568593, nil, nil, nil, nil)

var personGroupDelete* = Call_PersonGroupDelete_568587(name: "personGroupDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupDelete_568588,
    base: "", url: url_PersonGroupDelete_568589, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonCreate_568613 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonCreate_568615(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonCreate_568614(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new person in a specified person group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568616 = path.getOrDefault("personGroupId")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "personGroupId", valid_568616
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568618: Call_PersonGroupPersonCreate_568613; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new person in a specified person group.
  ## 
  let valid = call_568618.validator(path, query, header, formData, body)
  let scheme = call_568618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568618.url(scheme.get, call_568618.host, call_568618.base,
                         call_568618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568618, url, valid)

proc call*(call_568619: Call_PersonGroupPersonCreate_568613; personGroupId: string;
          body: JsonNode): Recallable =
  ## personGroupPersonCreate
  ## Create a new person in a specified person group.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  var path_568620 = newJObject()
  var body_568621 = newJObject()
  add(path_568620, "personGroupId", newJString(personGroupId))
  if body != nil:
    body_568621 = body
  result = call_568619.call(path_568620, nil, nil, nil, body_568621)

var personGroupPersonCreate* = Call_PersonGroupPersonCreate_568613(
    name: "personGroupPersonCreate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons",
    validator: validate_PersonGroupPersonCreate_568614, base: "",
    url: url_PersonGroupPersonCreate_568615, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonList_568603 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonList_568605(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonList_568604(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568606 = path.getOrDefault("personGroupId")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "personGroupId", valid_568606
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   start: JString
  ##        : Starting person id to return (used to list a range of persons).
  section = newJObject()
  var valid_568607 = query.getOrDefault("top")
  valid_568607 = validateParameter(valid_568607, JInt, required = false, default = nil)
  if valid_568607 != nil:
    section.add "top", valid_568607
  var valid_568608 = query.getOrDefault("start")
  valid_568608 = validateParameter(valid_568608, JString, required = false,
                                 default = nil)
  if valid_568608 != nil:
    section.add "start", valid_568608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568609: Call_PersonGroupPersonList_568603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  let valid = call_568609.validator(path, query, header, formData, body)
  let scheme = call_568609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568609.url(scheme.get, call_568609.host, call_568609.base,
                         call_568609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568609, url, valid)

proc call*(call_568610: Call_PersonGroupPersonList_568603; personGroupId: string;
          top: int = 0; start: string = ""): Recallable =
  ## personGroupPersonList
  ## List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   top: int
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   start: string
  ##        : Starting person id to return (used to list a range of persons).
  var path_568611 = newJObject()
  var query_568612 = newJObject()
  add(path_568611, "personGroupId", newJString(personGroupId))
  add(query_568612, "top", newJInt(top))
  add(query_568612, "start", newJString(start))
  result = call_568610.call(path_568611, query_568612, nil, nil, nil)

var personGroupPersonList* = Call_PersonGroupPersonList_568603(
    name: "personGroupPersonList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons",
    validator: validate_PersonGroupPersonList_568604, base: "",
    url: url_PersonGroupPersonList_568605, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonGet_568622 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonGet_568624(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonGet_568623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568625 = path.getOrDefault("personGroupId")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "personGroupId", valid_568625
  var valid_568626 = path.getOrDefault("personId")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "personId", valid_568626
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568627: Call_PersonGroupPersonGet_568622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ## 
  let valid = call_568627.validator(path, query, header, formData, body)
  let scheme = call_568627.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568627.url(scheme.get, call_568627.host, call_568627.base,
                         call_568627.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568627, url, valid)

proc call*(call_568628: Call_PersonGroupPersonGet_568622; personGroupId: string;
          personId: string): Recallable =
  ## personGroupPersonGet
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_568629 = newJObject()
  add(path_568629, "personGroupId", newJString(personGroupId))
  add(path_568629, "personId", newJString(personId))
  result = call_568628.call(path_568629, nil, nil, nil, nil)

var personGroupPersonGet* = Call_PersonGroupPersonGet_568622(
    name: "personGroupPersonGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonGet_568623, base: "",
    url: url_PersonGroupPersonGet_568624, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonUpdate_568638 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonUpdate_568640(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonUpdate_568639(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update name or userData of a person.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568641 = path.getOrDefault("personGroupId")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "personGroupId", valid_568641
  var valid_568642 = path.getOrDefault("personId")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "personId", valid_568642
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568644: Call_PersonGroupPersonUpdate_568638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update name or userData of a person.
  ## 
  let valid = call_568644.validator(path, query, header, formData, body)
  let scheme = call_568644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568644.url(scheme.get, call_568644.host, call_568644.base,
                         call_568644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568644, url, valid)

proc call*(call_568645: Call_PersonGroupPersonUpdate_568638; personGroupId: string;
          personId: string; body: JsonNode): Recallable =
  ## personGroupPersonUpdate
  ## Update name or userData of a person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  var path_568646 = newJObject()
  var body_568647 = newJObject()
  add(path_568646, "personGroupId", newJString(personGroupId))
  add(path_568646, "personId", newJString(personId))
  if body != nil:
    body_568647 = body
  result = call_568645.call(path_568646, nil, nil, nil, body_568647)

var personGroupPersonUpdate* = Call_PersonGroupPersonUpdate_568638(
    name: "personGroupPersonUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonUpdate_568639, base: "",
    url: url_PersonGroupPersonUpdate_568640, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonDelete_568630 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonDelete_568632(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonDelete_568631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568633 = path.getOrDefault("personGroupId")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "personGroupId", valid_568633
  var valid_568634 = path.getOrDefault("personId")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "personId", valid_568634
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568635: Call_PersonGroupPersonDelete_568630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  let valid = call_568635.validator(path, query, header, formData, body)
  let scheme = call_568635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568635.url(scheme.get, call_568635.host, call_568635.base,
                         call_568635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568635, url, valid)

proc call*(call_568636: Call_PersonGroupPersonDelete_568630; personGroupId: string;
          personId: string): Recallable =
  ## personGroupPersonDelete
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_568637 = newJObject()
  add(path_568637, "personGroupId", newJString(personGroupId))
  add(path_568637, "personId", newJString(personId))
  result = call_568636.call(path_568637, nil, nil, nil, nil)

var personGroupPersonDelete* = Call_PersonGroupPersonDelete_568630(
    name: "personGroupPersonDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonDelete_568631, base: "",
    url: url_PersonGroupPersonDelete_568632, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonAddFaceFromUrl_568648 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonAddFaceFromUrl_568650(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonAddFaceFromUrl_568649(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## *   Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## *   Each person entry can hold up to 248 faces.
  ## *   JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## *   "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## *   Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## *   Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [PersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523b). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568651 = path.getOrDefault("personGroupId")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "personGroupId", valid_568651
  var valid_568652 = path.getOrDefault("personId")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "personId", valid_568652
  result.add "path", section
  ## parameters in `query` object:
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  section = newJObject()
  var valid_568653 = query.getOrDefault("userData")
  valid_568653 = validateParameter(valid_568653, JString, required = false,
                                 default = nil)
  if valid_568653 != nil:
    section.add "userData", valid_568653
  var valid_568654 = query.getOrDefault("detectionModel")
  valid_568654 = validateParameter(valid_568654, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_568654 != nil:
    section.add "detectionModel", valid_568654
  var valid_568655 = query.getOrDefault("targetFace")
  valid_568655 = validateParameter(valid_568655, JArray, required = false,
                                 default = nil)
  if valid_568655 != nil:
    section.add "targetFace", valid_568655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568657: Call_PersonGroupPersonAddFaceFromUrl_568648;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## *   Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## *   Each person entry can hold up to 248 faces.
  ## *   JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## *   "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## *   Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## *   Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [PersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523b). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  let valid = call_568657.validator(path, query, header, formData, body)
  let scheme = call_568657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568657.url(scheme.get, call_568657.host, call_568657.base,
                         call_568657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568657, url, valid)

proc call*(call_568658: Call_PersonGroupPersonAddFaceFromUrl_568648;
          personGroupId: string; personId: string; ImageUrl: JsonNode;
          userData: string = ""; detectionModel: string = "detection_01";
          targetFace: JsonNode = nil): Recallable =
  ## personGroupPersonAddFaceFromUrl
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## *   Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## *   Each person entry can hold up to 248 faces.
  ## *   JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## *   "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## *   Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## *   Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [PersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523b). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  var path_568659 = newJObject()
  var query_568660 = newJObject()
  var body_568661 = newJObject()
  add(path_568659, "personGroupId", newJString(personGroupId))
  add(path_568659, "personId", newJString(personId))
  add(query_568660, "userData", newJString(userData))
  if ImageUrl != nil:
    body_568661 = ImageUrl
  add(query_568660, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_568660.add "targetFace", targetFace
  result = call_568658.call(path_568659, query_568660, nil, nil, body_568661)

var personGroupPersonAddFaceFromUrl* = Call_PersonGroupPersonAddFaceFromUrl_568648(
    name: "personGroupPersonAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces",
    validator: validate_PersonGroupPersonAddFaceFromUrl_568649, base: "",
    url: url_PersonGroupPersonAddFaceFromUrl_568650, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonGetFace_568662 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonGetFace_568664(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonGetFace_568663(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568665 = path.getOrDefault("personGroupId")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "personGroupId", valid_568665
  var valid_568666 = path.getOrDefault("persistedFaceId")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "persistedFaceId", valid_568666
  var valid_568667 = path.getOrDefault("personId")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "personId", valid_568667
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568668: Call_PersonGroupPersonGetFace_568662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ## 
  let valid = call_568668.validator(path, query, header, formData, body)
  let scheme = call_568668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568668.url(scheme.get, call_568668.host, call_568668.base,
                         call_568668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568668, url, valid)

proc call*(call_568669: Call_PersonGroupPersonGetFace_568662;
          personGroupId: string; persistedFaceId: string; personId: string): Recallable =
  ## personGroupPersonGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_568670 = newJObject()
  add(path_568670, "personGroupId", newJString(personGroupId))
  add(path_568670, "persistedFaceId", newJString(persistedFaceId))
  add(path_568670, "personId", newJString(personId))
  result = call_568669.call(path_568670, nil, nil, nil, nil)

var personGroupPersonGetFace* = Call_PersonGroupPersonGetFace_568662(
    name: "personGroupPersonGetFace", meth: HttpMethod.HttpGet, host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonGetFace_568663, base: "",
    url: url_PersonGroupPersonGetFace_568664, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonUpdateFace_568680 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonUpdateFace_568682(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonUpdateFace_568681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568683 = path.getOrDefault("personGroupId")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "personGroupId", valid_568683
  var valid_568684 = path.getOrDefault("persistedFaceId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "persistedFaceId", valid_568684
  var valid_568685 = path.getOrDefault("personId")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "personId", valid_568685
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568687: Call_PersonGroupPersonUpdateFace_568680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  let valid = call_568687.validator(path, query, header, formData, body)
  let scheme = call_568687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568687.url(scheme.get, call_568687.host, call_568687.base,
                         call_568687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568687, url, valid)

proc call*(call_568688: Call_PersonGroupPersonUpdateFace_568680;
          personGroupId: string; persistedFaceId: string; personId: string;
          body: JsonNode): Recallable =
  ## personGroupPersonUpdateFace
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  var path_568689 = newJObject()
  var body_568690 = newJObject()
  add(path_568689, "personGroupId", newJString(personGroupId))
  add(path_568689, "persistedFaceId", newJString(persistedFaceId))
  add(path_568689, "personId", newJString(personId))
  if body != nil:
    body_568690 = body
  result = call_568688.call(path_568689, nil, nil, nil, body_568690)

var personGroupPersonUpdateFace* = Call_PersonGroupPersonUpdateFace_568680(
    name: "personGroupPersonUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonUpdateFace_568681, base: "",
    url: url_PersonGroupPersonUpdateFace_568682, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonDeleteFace_568671 = ref object of OpenApiRestCall_567668
proc url_PersonGroupPersonDeleteFace_568673(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonDeleteFace_568672(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568674 = path.getOrDefault("personGroupId")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "personGroupId", valid_568674
  var valid_568675 = path.getOrDefault("persistedFaceId")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "persistedFaceId", valid_568675
  var valid_568676 = path.getOrDefault("personId")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "personId", valid_568676
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568677: Call_PersonGroupPersonDeleteFace_568671; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  let valid = call_568677.validator(path, query, header, formData, body)
  let scheme = call_568677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568677.url(scheme.get, call_568677.host, call_568677.base,
                         call_568677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568677, url, valid)

proc call*(call_568678: Call_PersonGroupPersonDeleteFace_568671;
          personGroupId: string; persistedFaceId: string; personId: string): Recallable =
  ## personGroupPersonDeleteFace
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_568679 = newJObject()
  add(path_568679, "personGroupId", newJString(personGroupId))
  add(path_568679, "persistedFaceId", newJString(persistedFaceId))
  add(path_568679, "personId", newJString(personId))
  result = call_568678.call(path_568679, nil, nil, nil, nil)

var personGroupPersonDeleteFace* = Call_PersonGroupPersonDeleteFace_568671(
    name: "personGroupPersonDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonDeleteFace_568672, base: "",
    url: url_PersonGroupPersonDeleteFace_568673, schemes: {Scheme.Https})
type
  Call_PersonGroupTrain_568691 = ref object of OpenApiRestCall_567668
proc url_PersonGroupTrain_568693(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupTrain_568692(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Queue a person group training task, the training task may not be started immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568694 = path.getOrDefault("personGroupId")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "personGroupId", valid_568694
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568695: Call_PersonGroupTrain_568691; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a person group training task, the training task may not be started immediately.
  ## 
  let valid = call_568695.validator(path, query, header, formData, body)
  let scheme = call_568695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568695.url(scheme.get, call_568695.host, call_568695.base,
                         call_568695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568695, url, valid)

proc call*(call_568696: Call_PersonGroupTrain_568691; personGroupId: string): Recallable =
  ## personGroupTrain
  ## Queue a person group training task, the training task may not be started immediately.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_568697 = newJObject()
  add(path_568697, "personGroupId", newJString(personGroupId))
  result = call_568696.call(path_568697, nil, nil, nil, nil)

var personGroupTrain* = Call_PersonGroupTrain_568691(name: "personGroupTrain",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/persongroups/{personGroupId}/train",
    validator: validate_PersonGroupTrain_568692, base: "",
    url: url_PersonGroupTrain_568693, schemes: {Scheme.Https})
type
  Call_PersonGroupGetTrainingStatus_568698 = ref object of OpenApiRestCall_567668
proc url_PersonGroupGetTrainingStatus_568700(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/training")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupGetTrainingStatus_568699(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the training status of a person group (completed or ongoing).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_568701 = path.getOrDefault("personGroupId")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "personGroupId", valid_568701
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568702: Call_PersonGroupGetTrainingStatus_568698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the training status of a person group (completed or ongoing).
  ## 
  let valid = call_568702.validator(path, query, header, formData, body)
  let scheme = call_568702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568702.url(scheme.get, call_568702.host, call_568702.base,
                         call_568702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568702, url, valid)

proc call*(call_568703: Call_PersonGroupGetTrainingStatus_568698;
          personGroupId: string): Recallable =
  ## personGroupGetTrainingStatus
  ## Retrieve the training status of a person group (completed or ongoing).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_568704 = newJObject()
  add(path_568704, "personGroupId", newJString(personGroupId))
  result = call_568703.call(path_568704, nil, nil, nil, nil)

var personGroupGetTrainingStatus* = Call_PersonGroupGetTrainingStatus_568698(
    name: "personGroupGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/persongroups/{personGroupId}/training",
    validator: validate_PersonGroupGetTrainingStatus_568699, base: "",
    url: url_PersonGroupGetTrainingStatus_568700, schemes: {Scheme.Https})
type
  Call_SnapshotTake_568713 = ref object of OpenApiRestCall_567668
proc url_SnapshotTake_568715(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SnapshotTake_568714(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit an operation to take a snapshot of face list, large face list, person group or large person group, with user-specified snapshot type, source object id, apply scope and an optional user data.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Taking snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of creating the snapshot. The snapshot id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot taking time depends on the number of person and face entries in the source object. It could be in seconds, or up to several hours for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. User can delete the snapshot using Snapshot - Delete by themselves any time before expiration.<br />
  ## Taking snapshot for a certain object will not block any other operations against the object. All read-only operations (Get/List and Identify/FindSimilar/Verify) can be conducted as usual. For all writable operations, including Add/Update/Delete the source object or its persons/faces and Train, they are not blocked but not recommended because writable updates may not be reflected on the snapshot during its taking. After snapshot taking is completed, all readable and writable operations can work as normal. Snapshot will also include the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## * Free-tier subscription quota: 100 take operations per month.
  ## * S0-tier subscription quota: 100 take operations per day.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for taking a snapshot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568717: Call_SnapshotTake_568713; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit an operation to take a snapshot of face list, large face list, person group or large person group, with user-specified snapshot type, source object id, apply scope and an optional user data.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Taking snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of creating the snapshot. The snapshot id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot taking time depends on the number of person and face entries in the source object. It could be in seconds, or up to several hours for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. User can delete the snapshot using Snapshot - Delete by themselves any time before expiration.<br />
  ## Taking snapshot for a certain object will not block any other operations against the object. All read-only operations (Get/List and Identify/FindSimilar/Verify) can be conducted as usual. For all writable operations, including Add/Update/Delete the source object or its persons/faces and Train, they are not blocked but not recommended because writable updates may not be reflected on the snapshot during its taking. After snapshot taking is completed, all readable and writable operations can work as normal. Snapshot will also include the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## * Free-tier subscription quota: 100 take operations per month.
  ## * S0-tier subscription quota: 100 take operations per day.
  ## 
  let valid = call_568717.validator(path, query, header, formData, body)
  let scheme = call_568717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568717.url(scheme.get, call_568717.host, call_568717.base,
                         call_568717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568717, url, valid)

proc call*(call_568718: Call_SnapshotTake_568713; body: JsonNode): Recallable =
  ## snapshotTake
  ## Submit an operation to take a snapshot of face list, large face list, person group or large person group, with user-specified snapshot type, source object id, apply scope and an optional user data.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Taking snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of creating the snapshot. The snapshot id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot taking time depends on the number of person and face entries in the source object. It could be in seconds, or up to several hours for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. User can delete the snapshot using Snapshot - Delete by themselves any time before expiration.<br />
  ## Taking snapshot for a certain object will not block any other operations against the object. All read-only operations (Get/List and Identify/FindSimilar/Verify) can be conducted as usual. For all writable operations, including Add/Update/Delete the source object or its persons/faces and Train, they are not blocked but not recommended because writable updates may not be reflected on the snapshot during its taking. After snapshot taking is completed, all readable and writable operations can work as normal. Snapshot will also include the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## * Free-tier subscription quota: 100 take operations per month.
  ## * S0-tier subscription quota: 100 take operations per day.
  ##   body: JObject (required)
  ##       : Request body for taking a snapshot.
  var body_568719 = newJObject()
  if body != nil:
    body_568719 = body
  result = call_568718.call(nil, nil, nil, nil, body_568719)

var snapshotTake* = Call_SnapshotTake_568713(name: "snapshotTake",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/snapshots",
    validator: validate_SnapshotTake_568714, base: "", url: url_SnapshotTake_568715,
    schemes: {Scheme.Https})
type
  Call_SnapshotList_568705 = ref object of OpenApiRestCall_567668
proc url_SnapshotList_568707(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SnapshotList_568706(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   applyScope: JArray
  ##             : User specified snapshot apply scopes as a search filter. ApplyScope is an array of the target Azure subscription ids for the snapshot, specified by the user who created the snapshot by Snapshot - Take.
  ##   type: JString
  ##       : User specified object type as a search filter.
  section = newJObject()
  var valid_568708 = query.getOrDefault("applyScope")
  valid_568708 = validateParameter(valid_568708, JArray, required = false,
                                 default = nil)
  if valid_568708 != nil:
    section.add "applyScope", valid_568708
  var valid_568709 = query.getOrDefault("type")
  valid_568709 = validateParameter(valid_568709, JString, required = false,
                                 default = newJString("FaceList"))
  if valid_568709 != nil:
    section.add "type", valid_568709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568710: Call_SnapshotList_568705; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ## 
  let valid = call_568710.validator(path, query, header, formData, body)
  let scheme = call_568710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568710.url(scheme.get, call_568710.host, call_568710.base,
                         call_568710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568710, url, valid)

proc call*(call_568711: Call_SnapshotList_568705; applyScope: JsonNode = nil;
          `type`: string = "FaceList"): Recallable =
  ## snapshotList
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ##   applyScope: JArray
  ##             : User specified snapshot apply scopes as a search filter. ApplyScope is an array of the target Azure subscription ids for the snapshot, specified by the user who created the snapshot by Snapshot - Take.
  ##   type: string
  ##       : User specified object type as a search filter.
  var query_568712 = newJObject()
  if applyScope != nil:
    query_568712.add "applyScope", applyScope
  add(query_568712, "type", newJString(`type`))
  result = call_568711.call(nil, query_568712, nil, nil, nil)

var snapshotList* = Call_SnapshotList_568705(name: "snapshotList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/snapshots",
    validator: validate_SnapshotList_568706, base: "", url: url_SnapshotList_568707,
    schemes: {Scheme.Https})
type
  Call_SnapshotGet_568720 = ref object of OpenApiRestCall_567668
proc url_SnapshotGet_568722(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotGet_568721(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a snapshot. Snapshot is only accessible to the source subscription who took it, and target subscriptions included in the applyScope in Snapshot - Take.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : Id referencing a particular snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_568723 = path.getOrDefault("snapshotId")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "snapshotId", valid_568723
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568724: Call_SnapshotGet_568720; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a snapshot. Snapshot is only accessible to the source subscription who took it, and target subscriptions included in the applyScope in Snapshot - Take.
  ## 
  let valid = call_568724.validator(path, query, header, formData, body)
  let scheme = call_568724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568724.url(scheme.get, call_568724.host, call_568724.base,
                         call_568724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568724, url, valid)

proc call*(call_568725: Call_SnapshotGet_568720; snapshotId: string): Recallable =
  ## snapshotGet
  ## Retrieve information about a snapshot. Snapshot is only accessible to the source subscription who took it, and target subscriptions included in the applyScope in Snapshot - Take.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  var path_568726 = newJObject()
  add(path_568726, "snapshotId", newJString(snapshotId))
  result = call_568725.call(path_568726, nil, nil, nil, nil)

var snapshotGet* = Call_SnapshotGet_568720(name: "snapshotGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/snapshots/{snapshotId}",
                                        validator: validate_SnapshotGet_568721,
                                        base: "", url: url_SnapshotGet_568722,
                                        schemes: {Scheme.Https})
type
  Call_SnapshotUpdate_568734 = ref object of OpenApiRestCall_567668
proc url_SnapshotUpdate_568736(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotUpdate_568735(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update the information of a snapshot. Only the source subscription who took the snapshot can update the snapshot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : Id referencing a particular snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_568737 = path.getOrDefault("snapshotId")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "snapshotId", valid_568737
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating a snapshot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568739: Call_SnapshotUpdate_568734; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the information of a snapshot. Only the source subscription who took the snapshot can update the snapshot.
  ## 
  let valid = call_568739.validator(path, query, header, formData, body)
  let scheme = call_568739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568739.url(scheme.get, call_568739.host, call_568739.base,
                         call_568739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568739, url, valid)

proc call*(call_568740: Call_SnapshotUpdate_568734; snapshotId: string;
          body: JsonNode): Recallable =
  ## snapshotUpdate
  ## Update the information of a snapshot. Only the source subscription who took the snapshot can update the snapshot.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  ##   body: JObject (required)
  ##       : Request body for updating a snapshot.
  var path_568741 = newJObject()
  var body_568742 = newJObject()
  add(path_568741, "snapshotId", newJString(snapshotId))
  if body != nil:
    body_568742 = body
  result = call_568740.call(path_568741, nil, nil, nil, body_568742)

var snapshotUpdate* = Call_SnapshotUpdate_568734(name: "snapshotUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/snapshots/{snapshotId}", validator: validate_SnapshotUpdate_568735,
    base: "", url: url_SnapshotUpdate_568736, schemes: {Scheme.Https})
type
  Call_SnapshotDelete_568727 = ref object of OpenApiRestCall_567668
proc url_SnapshotDelete_568729(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotDelete_568728(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete an existing snapshot according to the snapshotId. All object data and information in the snapshot will also be deleted. Only the source subscription who took the snapshot can delete the snapshot. If the user does not delete a snapshot with this API, the snapshot will still be automatically deleted in 48 hours after creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : Id referencing a particular snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_568730 = path.getOrDefault("snapshotId")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "snapshotId", valid_568730
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568731: Call_SnapshotDelete_568727; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing snapshot according to the snapshotId. All object data and information in the snapshot will also be deleted. Only the source subscription who took the snapshot can delete the snapshot. If the user does not delete a snapshot with this API, the snapshot will still be automatically deleted in 48 hours after creation.
  ## 
  let valid = call_568731.validator(path, query, header, formData, body)
  let scheme = call_568731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568731.url(scheme.get, call_568731.host, call_568731.base,
                         call_568731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568731, url, valid)

proc call*(call_568732: Call_SnapshotDelete_568727; snapshotId: string): Recallable =
  ## snapshotDelete
  ## Delete an existing snapshot according to the snapshotId. All object data and information in the snapshot will also be deleted. Only the source subscription who took the snapshot can delete the snapshot. If the user does not delete a snapshot with this API, the snapshot will still be automatically deleted in 48 hours after creation.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  var path_568733 = newJObject()
  add(path_568733, "snapshotId", newJString(snapshotId))
  result = call_568732.call(path_568733, nil, nil, nil, nil)

var snapshotDelete* = Call_SnapshotDelete_568727(name: "snapshotDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/snapshots/{snapshotId}", validator: validate_SnapshotDelete_568728,
    base: "", url: url_SnapshotDelete_568729, schemes: {Scheme.Https})
type
  Call_SnapshotApply_568743 = ref object of OpenApiRestCall_567668
proc url_SnapshotApply_568745(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId"),
               (kind: ConstantSegment, value: "/apply")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotApply_568744(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit an operation to apply a snapshot to current subscription. For each snapshot, only subscriptions included in the applyScope of Snapshot - Take can apply it.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Applying snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of applying the snapshot. The target object id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot applying time depends on the number of person and face entries in the snapshot object. It could be in seconds, or up to 1 hour for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. So the target subscription is required to apply the snapshot in 48 hours since its creation.<br />
  ## Applying a snapshot will not block any other operations against the target object, however it is not recommended because the correctness cannot be guaranteed during snapshot applying. After snapshot applying is completed, all operations towards the target object can work as normal. Snapshot also includes the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## One snapshot can be applied multiple times in parallel, while currently only CreateNew apply mode is supported, which means the apply operation will fail if target subscription already contains an object of same type and using the same objectId. Users can specify the "objectId" in request body to avoid such conflicts.<br />
  ## * Free-tier subscription quota: 100 apply operations per month.
  ## * S0-tier subscription quota: 100 apply operations per day.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : Id referencing a particular snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_568746 = path.getOrDefault("snapshotId")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "snapshotId", valid_568746
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for applying a snapshot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568748: Call_SnapshotApply_568743; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit an operation to apply a snapshot to current subscription. For each snapshot, only subscriptions included in the applyScope of Snapshot - Take can apply it.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Applying snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of applying the snapshot. The target object id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot applying time depends on the number of person and face entries in the snapshot object. It could be in seconds, or up to 1 hour for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. So the target subscription is required to apply the snapshot in 48 hours since its creation.<br />
  ## Applying a snapshot will not block any other operations against the target object, however it is not recommended because the correctness cannot be guaranteed during snapshot applying. After snapshot applying is completed, all operations towards the target object can work as normal. Snapshot also includes the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## One snapshot can be applied multiple times in parallel, while currently only CreateNew apply mode is supported, which means the apply operation will fail if target subscription already contains an object of same type and using the same objectId. Users can specify the "objectId" in request body to avoid such conflicts.<br />
  ## * Free-tier subscription quota: 100 apply operations per month.
  ## * S0-tier subscription quota: 100 apply operations per day.
  ## 
  let valid = call_568748.validator(path, query, header, formData, body)
  let scheme = call_568748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568748.url(scheme.get, call_568748.host, call_568748.base,
                         call_568748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568748, url, valid)

proc call*(call_568749: Call_SnapshotApply_568743; snapshotId: string; body: JsonNode): Recallable =
  ## snapshotApply
  ## Submit an operation to apply a snapshot to current subscription. For each snapshot, only subscriptions included in the applyScope of Snapshot - Take can apply it.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Applying snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of applying the snapshot. The target object id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot applying time depends on the number of person and face entries in the snapshot object. It could be in seconds, or up to 1 hour for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. So the target subscription is required to apply the snapshot in 48 hours since its creation.<br />
  ## Applying a snapshot will not block any other operations against the target object, however it is not recommended because the correctness cannot be guaranteed during snapshot applying. After snapshot applying is completed, all operations towards the target object can work as normal. Snapshot also includes the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## One snapshot can be applied multiple times in parallel, while currently only CreateNew apply mode is supported, which means the apply operation will fail if target subscription already contains an object of same type and using the same objectId. Users can specify the "objectId" in request body to avoid such conflicts.<br />
  ## * Free-tier subscription quota: 100 apply operations per month.
  ## * S0-tier subscription quota: 100 apply operations per day.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  ##   body: JObject (required)
  ##       : Request body for applying a snapshot.
  var path_568750 = newJObject()
  var body_568751 = newJObject()
  add(path_568750, "snapshotId", newJString(snapshotId))
  if body != nil:
    body_568751 = body
  result = call_568749.call(path_568750, nil, nil, nil, body_568751)

var snapshotApply* = Call_SnapshotApply_568743(name: "snapshotApply",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/snapshots/{snapshotId}/apply", validator: validate_SnapshotApply_568744,
    base: "", url: url_SnapshotApply_568745, schemes: {Scheme.Https})
type
  Call_FaceVerifyFaceToFace_568752 = ref object of OpenApiRestCall_567668
proc url_FaceVerifyFaceToFace_568754(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceVerifyFaceToFace_568753(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify whether two faces belong to a same person or whether one face belongs to a person.
  ## <br/>
  ## Remarks:<br />
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * For the scenarios that are sensitive to accuracy please make your own judgment.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target face, person group or large person group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for face to face verification.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568756: Call_FaceVerifyFaceToFace_568752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verify whether two faces belong to a same person or whether one face belongs to a person.
  ## <br/>
  ## Remarks:<br />
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * For the scenarios that are sensitive to accuracy please make your own judgment.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target face, person group or large person group.
  ## 
  ## 
  let valid = call_568756.validator(path, query, header, formData, body)
  let scheme = call_568756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568756.url(scheme.get, call_568756.host, call_568756.base,
                         call_568756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568756, url, valid)

proc call*(call_568757: Call_FaceVerifyFaceToFace_568752; body: JsonNode): Recallable =
  ## faceVerifyFaceToFace
  ## Verify whether two faces belong to a same person or whether one face belongs to a person.
  ## <br/>
  ## Remarks:<br />
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * For the scenarios that are sensitive to accuracy please make your own judgment.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target face, person group or large person group.
  ## 
  ##   body: JObject (required)
  ##       : Request body for face to face verification.
  var body_568758 = newJObject()
  if body != nil:
    body_568758 = body
  result = call_568757.call(nil, nil, nil, nil, body_568758)

var faceVerifyFaceToFace* = Call_FaceVerifyFaceToFace_568752(
    name: "faceVerifyFaceToFace", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/verify", validator: validate_FaceVerifyFaceToFace_568753, base: "",
    url: url_FaceVerifyFaceToFace_568754, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
