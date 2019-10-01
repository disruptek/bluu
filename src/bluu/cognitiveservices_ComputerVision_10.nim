
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Computer Vision
## version: 1.0
## termsOfService: (not provided)
## license: (not provided)
## 
## The Computer Vision API provides state-of-the-art algorithms to process images and return information. For example, it can be used to determine if an image contains mature content, or it can be used to find all the faces in an image.  It also has other features like estimating dominant and accent colors, categorizing the content of images, and describing an image with complete English sentences.  Additionally, it can also intelligently generate images thumbnails for displaying large images effectively.
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices-ComputerVision"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyzeImage_567880 = ref object of OpenApiRestCall_567658
proc url_AnalyzeImage_567882(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyzeImage_567881(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   visualFeatures: JArray
  ##                 : A string indicating what visual feature types to return. Multiple values should be comma-separated. Valid visual feature types include:Categories - categorizes image content according to a taxonomy defined in documentation. Tags - tags the image with a detailed list of words related to the image content. Description - describes the image content with a complete English sentence. Faces - detects if faces are present. If present, generate coordinates, gender and age. ImageType - detects if image is clipart or a line drawing. Color - determines the accent color, dominant color, and whether an image is black&white.Adult - detects if the image is pornographic in nature (depicts nudity or a sex act).  Sexually suggestive content is also detected.
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   details: JArray
  ##          : A string indicating which domain-specific details to return. Multiple values should be comma-separated. Valid visual feature types include:Celebrities - identifies celebrities if detected in the image.
  section = newJObject()
  var valid_568041 = query.getOrDefault("visualFeatures")
  valid_568041 = validateParameter(valid_568041, JArray, required = false,
                                 default = nil)
  if valid_568041 != nil:
    section.add "visualFeatures", valid_568041
  var valid_568055 = query.getOrDefault("language")
  valid_568055 = validateParameter(valid_568055, JString, required = false,
                                 default = newJString("en"))
  if valid_568055 != nil:
    section.add "language", valid_568055
  var valid_568056 = query.getOrDefault("details")
  valid_568056 = validateParameter(valid_568056, JArray, required = false,
                                 default = nil)
  if valid_568056 != nil:
    section.add "details", valid_568056
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

proc call*(call_568080: Call_AnalyzeImage_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_AnalyzeImage_567880; ImageUrl: JsonNode;
          visualFeatures: JsonNode = nil; language: string = "en";
          details: JsonNode = nil): Recallable =
  ## analyzeImage
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ##   visualFeatures: JArray
  ##                 : A string indicating what visual feature types to return. Multiple values should be comma-separated. Valid visual feature types include:Categories - categorizes image content according to a taxonomy defined in documentation. Tags - tags the image with a detailed list of words related to the image content. Description - describes the image content with a complete English sentence. Faces - detects if faces are present. If present, generate coordinates, gender and age. ImageType - detects if image is clipart or a line drawing. Color - determines the accent color, dominant color, and whether an image is black&white.Adult - detects if the image is pornographic in nature (depicts nudity or a sex act).  Sexually suggestive content is also detected.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   details: JArray
  ##          : A string indicating which domain-specific details to return. Multiple values should be comma-separated. Valid visual feature types include:Celebrities - identifies celebrities if detected in the image.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_568152 = newJObject()
  var body_568154 = newJObject()
  if visualFeatures != nil:
    query_568152.add "visualFeatures", visualFeatures
  add(query_568152, "language", newJString(language))
  if details != nil:
    query_568152.add "details", details
  if ImageUrl != nil:
    body_568154 = ImageUrl
  result = call_568151.call(nil, query_568152, nil, nil, body_568154)

var analyzeImage* = Call_AnalyzeImage_567880(name: "analyzeImage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/analyze",
    validator: validate_AnalyzeImage_567881, base: "/vision/v1.0",
    url: url_AnalyzeImage_567882, schemes: {Scheme.Https})
type
  Call_DescribeImage_568193 = ref object of OpenApiRestCall_567658
proc url_DescribeImage_568195(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DescribeImage_568194(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   maxCandidates: JString
  ##                : Maximum number of candidate descriptions to be returned.  The default is 1.
  section = newJObject()
  var valid_568196 = query.getOrDefault("language")
  valid_568196 = validateParameter(valid_568196, JString, required = false,
                                 default = newJString("en"))
  if valid_568196 != nil:
    section.add "language", valid_568196
  var valid_568197 = query.getOrDefault("maxCandidates")
  valid_568197 = validateParameter(valid_568197, JString, required = false,
                                 default = newJString("1"))
  if valid_568197 != nil:
    section.add "maxCandidates", valid_568197
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

proc call*(call_568199: Call_DescribeImage_568193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_DescribeImage_568193; ImageUrl: JsonNode;
          language: string = "en"; maxCandidates: string = "1"): Recallable =
  ## describeImage
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   maxCandidates: string
  ##                : Maximum number of candidate descriptions to be returned.  The default is 1.
  var query_568201 = newJObject()
  var body_568202 = newJObject()
  add(query_568201, "language", newJString(language))
  if ImageUrl != nil:
    body_568202 = ImageUrl
  add(query_568201, "maxCandidates", newJString(maxCandidates))
  result = call_568200.call(nil, query_568201, nil, nil, body_568202)

var describeImage* = Call_DescribeImage_568193(name: "describeImage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/describe",
    validator: validate_DescribeImage_568194, base: "/vision/v1.0",
    url: url_DescribeImage_568195, schemes: {Scheme.Https})
type
  Call_GenerateThumbnail_568203 = ref object of OpenApiRestCall_567658
proc url_GenerateThumbnail_568205(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GenerateThumbnail_568204(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This operation generates a thumbnail image with the user-specified width and height. By default, the service analyzes the image, identifies the region of interest (ROI), and generates smart cropping coordinates based on the ROI. Smart cropping helps when you specify an aspect ratio that differs from that of the input image. A successful response contains the thumbnail image binary. If the request failed, the response contains an error code and a message to help determine what went wrong.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   height: JInt (required)
  ##         : Height of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   width: JInt (required)
  ##        : Width of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   smartCropping: JBool
  ##                : Boolean flag for enabling smart cropping.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `height` field"
  var valid_568206 = query.getOrDefault("height")
  valid_568206 = validateParameter(valid_568206, JInt, required = true, default = nil)
  if valid_568206 != nil:
    section.add "height", valid_568206
  var valid_568207 = query.getOrDefault("width")
  valid_568207 = validateParameter(valid_568207, JInt, required = true, default = nil)
  if valid_568207 != nil:
    section.add "width", valid_568207
  var valid_568208 = query.getOrDefault("smartCropping")
  valid_568208 = validateParameter(valid_568208, JBool, required = false,
                                 default = newJBool(false))
  if valid_568208 != nil:
    section.add "smartCropping", valid_568208
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

proc call*(call_568210: Call_GenerateThumbnail_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a thumbnail image with the user-specified width and height. By default, the service analyzes the image, identifies the region of interest (ROI), and generates smart cropping coordinates based on the ROI. Smart cropping helps when you specify an aspect ratio that differs from that of the input image. A successful response contains the thumbnail image binary. If the request failed, the response contains an error code and a message to help determine what went wrong.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_GenerateThumbnail_568203; height: int;
          ImageUrl: JsonNode; width: int; smartCropping: bool = false): Recallable =
  ## generateThumbnail
  ## This operation generates a thumbnail image with the user-specified width and height. By default, the service analyzes the image, identifies the region of interest (ROI), and generates smart cropping coordinates based on the ROI. Smart cropping helps when you specify an aspect ratio that differs from that of the input image. A successful response contains the thumbnail image binary. If the request failed, the response contains an error code and a message to help determine what went wrong.
  ##   height: int (required)
  ##         : Height of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   width: int (required)
  ##        : Width of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   smartCropping: bool
  ##                : Boolean flag for enabling smart cropping.
  var query_568212 = newJObject()
  var body_568213 = newJObject()
  add(query_568212, "height", newJInt(height))
  if ImageUrl != nil:
    body_568213 = ImageUrl
  add(query_568212, "width", newJInt(width))
  add(query_568212, "smartCropping", newJBool(smartCropping))
  result = call_568211.call(nil, query_568212, nil, nil, body_568213)

var generateThumbnail* = Call_GenerateThumbnail_568203(name: "generateThumbnail",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/generateThumbnail",
    validator: validate_GenerateThumbnail_568204, base: "/vision/v1.0",
    url: url_GenerateThumbnail_568205, schemes: {Scheme.Https})
type
  Call_ListModels_568214 = ref object of OpenApiRestCall_567658
proc url_ListModels_568216(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListModels_568215(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation returns the list of domain-specific models that are supported by the Computer Vision API.  Currently, the API only supports one domain-specific model: a celebrity recognizer. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
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
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_ListModels_568214; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns the list of domain-specific models that are supported by the Computer Vision API.  Currently, the API only supports one domain-specific model: a celebrity recognizer. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_ListModels_568214): Recallable =
  ## listModels
  ## This operation returns the list of domain-specific models that are supported by the Computer Vision API.  Currently, the API only supports one domain-specific model: a celebrity recognizer. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  result = call_568218.call(nil, nil, nil, nil, nil)

var listModels* = Call_ListModels_568214(name: "listModels",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/models",
                                      validator: validate_ListModels_568215,
                                      base: "/vision/v1.0", url: url_ListModels_568216,
                                      schemes: {Scheme.Https})
type
  Call_AnalyzeImageByDomain_568219 = ref object of OpenApiRestCall_567658
proc url_AnalyzeImageByDomain_568221(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "model"),
               (kind: ConstantSegment, value: "/analyze")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyzeImageByDomain_568220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation recognizes content within an image by applying a domain-specific model.  The list of domain-specific models that are supported by the Computer Vision API can be retrieved using the /models GET request.  Currently, the API only provides a single domain-specific model: celebrities. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : The domain-specific content to recognize.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_568236 = path.getOrDefault("model")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "model", valid_568236
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  section = newJObject()
  var valid_568237 = query.getOrDefault("language")
  valid_568237 = validateParameter(valid_568237, JString, required = false,
                                 default = newJString("en"))
  if valid_568237 != nil:
    section.add "language", valid_568237
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

proc call*(call_568239: Call_AnalyzeImageByDomain_568219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation recognizes content within an image by applying a domain-specific model.  The list of domain-specific models that are supported by the Computer Vision API can be retrieved using the /models GET request.  Currently, the API only provides a single domain-specific model: celebrities. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_AnalyzeImageByDomain_568219; ImageUrl: JsonNode;
          model: string; language: string = "en"): Recallable =
  ## analyzeImageByDomain
  ## This operation recognizes content within an image by applying a domain-specific model.  The list of domain-specific models that are supported by the Computer Vision API can be retrieved using the /models GET request.  Currently, the API only provides a single domain-specific model: celebrities. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   model: string (required)
  ##        : The domain-specific content to recognize.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  var body_568243 = newJObject()
  add(query_568242, "language", newJString(language))
  if ImageUrl != nil:
    body_568243 = ImageUrl
  add(path_568241, "model", newJString(model))
  result = call_568240.call(path_568241, query_568242, nil, nil, body_568243)

var analyzeImageByDomain* = Call_AnalyzeImageByDomain_568219(
    name: "analyzeImageByDomain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/models/{model}/analyze", validator: validate_AnalyzeImageByDomain_568220,
    base: "/vision/v1.0", url: url_AnalyzeImageByDomain_568221,
    schemes: {Scheme.Https})
type
  Call_RecognizePrintedText_568244 = ref object of OpenApiRestCall_567658
proc url_RecognizePrintedText_568246(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecognizePrintedText_568245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The BCP-47 language code of the text to be detected in the image. The default value is 'unk'
  ##   detectOrientation: JBool (required)
  ##                    : Whether detect the text orientation in the image. With detectOrientation=true the OCR service tries to detect the image orientation and correct it before further processing (e.g. if it's upside-down). 
  section = newJObject()
  var valid_568247 = query.getOrDefault("language")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = newJString("unk"))
  if valid_568247 != nil:
    section.add "language", valid_568247
  assert query != nil,
        "query argument is necessary due to required `detectOrientation` field"
  var valid_568248 = query.getOrDefault("detectOrientation")
  valid_568248 = validateParameter(valid_568248, JBool, required = true,
                                 default = newJBool(true))
  if valid_568248 != nil:
    section.add "detectOrientation", valid_568248
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

proc call*(call_568250: Call_RecognizePrintedText_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_RecognizePrintedText_568244; ImageUrl: JsonNode;
          language: string = "unk"; detectOrientation: bool = true): Recallable =
  ## recognizePrintedText
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ##   language: string
  ##           : The BCP-47 language code of the text to be detected in the image. The default value is 'unk'
  ##   detectOrientation: bool (required)
  ##                    : Whether detect the text orientation in the image. With detectOrientation=true the OCR service tries to detect the image orientation and correct it before further processing (e.g. if it's upside-down). 
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_568252 = newJObject()
  var body_568253 = newJObject()
  add(query_568252, "language", newJString(language))
  add(query_568252, "detectOrientation", newJBool(detectOrientation))
  if ImageUrl != nil:
    body_568253 = ImageUrl
  result = call_568251.call(nil, query_568252, nil, nil, body_568253)

var recognizePrintedText* = Call_RecognizePrintedText_568244(
    name: "recognizePrintedText", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/ocr", validator: validate_RecognizePrintedText_568245,
    base: "/vision/v1.0", url: url_RecognizePrintedText_568246,
    schemes: {Scheme.Https})
type
  Call_RecognizeText_568254 = ref object of OpenApiRestCall_567658
proc url_RecognizeText_568256(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecognizeText_568255(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Recognize Text operation. When you use the Recognize Text interface, the response contains a field called 'Operation-Location'. The 'Operation-Location' field contains the URL that you must use for your Get Handwritten Text Operation Result operation.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   detectHandwriting: JBool
  ##                    : If 'true' is specified, handwriting recognition is performed. If this parameter is set to 'false' or is not specified, printed text recognition is performed.
  section = newJObject()
  var valid_568257 = query.getOrDefault("detectHandwriting")
  valid_568257 = validateParameter(valid_568257, JBool, required = false,
                                 default = newJBool(false))
  if valid_568257 != nil:
    section.add "detectHandwriting", valid_568257
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

proc call*(call_568259: Call_RecognizeText_568254; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recognize Text operation. When you use the Recognize Text interface, the response contains a field called 'Operation-Location'. The 'Operation-Location' field contains the URL that you must use for your Get Handwritten Text Operation Result operation.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_RecognizeText_568254; ImageUrl: JsonNode;
          detectHandwriting: bool = false): Recallable =
  ## recognizeText
  ## Recognize Text operation. When you use the Recognize Text interface, the response contains a field called 'Operation-Location'. The 'Operation-Location' field contains the URL that you must use for your Get Handwritten Text Operation Result operation.
  ##   detectHandwriting: bool
  ##                    : If 'true' is specified, handwriting recognition is performed. If this parameter is set to 'false' or is not specified, printed text recognition is performed.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_568261 = newJObject()
  var body_568262 = newJObject()
  add(query_568261, "detectHandwriting", newJBool(detectHandwriting))
  if ImageUrl != nil:
    body_568262 = ImageUrl
  result = call_568260.call(nil, query_568261, nil, nil, body_568262)

var recognizeText* = Call_RecognizeText_568254(name: "recognizeText",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/recognizeText",
    validator: validate_RecognizeText_568255, base: "/vision/v1.0",
    url: url_RecognizeText_568256, schemes: {Scheme.Https})
type
  Call_TagImage_568263 = ref object of OpenApiRestCall_567658
proc url_TagImage_568265(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TagImage_568264(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation generates a list of words, or tags, that are relevant to the content of the supplied image. The Computer Vision API can return tags based on objects, living beings, scenery or actions found in images. Unlike categories, tags are not organized according to a hierarchical classification system, but correspond to image content. Tags may contain hints to avoid ambiguity or provide context, for example the tag 'cello' may be accompanied by the hint 'musical instrument'. All tags are in English.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  section = newJObject()
  var valid_568266 = query.getOrDefault("language")
  valid_568266 = validateParameter(valid_568266, JString, required = false,
                                 default = newJString("en"))
  if valid_568266 != nil:
    section.add "language", valid_568266
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

proc call*(call_568268: Call_TagImage_568263; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a list of words, or tags, that are relevant to the content of the supplied image. The Computer Vision API can return tags based on objects, living beings, scenery or actions found in images. Unlike categories, tags are not organized according to a hierarchical classification system, but correspond to image content. Tags may contain hints to avoid ambiguity or provide context, for example the tag 'cello' may be accompanied by the hint 'musical instrument'. All tags are in English.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_TagImage_568263; ImageUrl: JsonNode;
          language: string = "en"): Recallable =
  ## tagImage
  ## This operation generates a list of words, or tags, that are relevant to the content of the supplied image. The Computer Vision API can return tags based on objects, living beings, scenery or actions found in images. Unlike categories, tags are not organized according to a hierarchical classification system, but correspond to image content. Tags may contain hints to avoid ambiguity or provide context, for example the tag 'cello' may be accompanied by the hint 'musical instrument'. All tags are in English.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_568270 = newJObject()
  var body_568271 = newJObject()
  add(query_568270, "language", newJString(language))
  if ImageUrl != nil:
    body_568271 = ImageUrl
  result = call_568269.call(nil, query_568270, nil, nil, body_568271)

var tagImage* = Call_TagImage_568263(name: "tagImage", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/tag",
                                  validator: validate_TagImage_568264,
                                  base: "/vision/v1.0", url: url_TagImage_568265,
                                  schemes: {Scheme.Https})
type
  Call_GetTextOperationResult_568272 = ref object of OpenApiRestCall_567658
proc url_GetTextOperationResult_568274(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/textOperations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetTextOperationResult_568273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This interface is used for getting text operation result. The URL to this interface should be retrieved from 'Operation-Location' field returned from Recognize Text interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Id of the text operation returned in the response of the 'Recognize Handwritten Text'
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_568275 = path.getOrDefault("operationId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "operationId", valid_568275
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_GetTextOperationResult_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This interface is used for getting text operation result. The URL to this interface should be retrieved from 'Operation-Location' field returned from Recognize Text interface.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_GetTextOperationResult_568272; operationId: string): Recallable =
  ## getTextOperationResult
  ## This interface is used for getting text operation result. The URL to this interface should be retrieved from 'Operation-Location' field returned from Recognize Text interface.
  ##   operationId: string (required)
  ##              : Id of the text operation returned in the response of the 'Recognize Handwritten Text'
  var path_568278 = newJObject()
  add(path_568278, "operationId", newJString(operationId))
  result = call_568277.call(path_568278, nil, nil, nil, nil)

var getTextOperationResult* = Call_GetTextOperationResult_568272(
    name: "getTextOperationResult", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/textOperations/{operationId}",
    validator: validate_GetTextOperationResult_568273, base: "/vision/v1.0",
    url: url_GetTextOperationResult_568274, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
