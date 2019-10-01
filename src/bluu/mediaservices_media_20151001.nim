
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: MediaServicesManagementClient
## version: 2015-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Media Services resource management APIs.
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
  macServiceName = "mediaservices-media"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Media Services REST API operations.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Media Services REST API operations.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Media Services REST API operations.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Media/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_MediaServiceCheckNameAvailability_568176 = ref object of OpenApiRestCall_567658
proc url_MediaServiceCheckNameAvailability_568178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Media/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceCheckNameAvailability_568177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the Media Service resource name is available. The name must be globally unique.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_MediaServiceCheckNameAvailability_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the Media Service resource name is available. The name must be globally unique.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_MediaServiceCheckNameAvailability_568176;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## mediaServiceCheckNameAvailability
  ## Checks whether the Media Service resource name is available. The name must be globally unique.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568227 = parameters
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var mediaServiceCheckNameAvailability* = Call_MediaServiceCheckNameAvailability_568176(
    name: "mediaServiceCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Media/CheckNameAvailability",
    validator: validate_MediaServiceCheckNameAvailability_568177, base: "",
    url: url_MediaServiceCheckNameAvailability_568178, schemes: {Scheme.Https})
type
  Call_MediaServiceListByResourceGroup_568228 = ref object of OpenApiRestCall_567658
proc url_MediaServiceListByResourceGroup_568230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceListByResourceGroup_568229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the Media Services in a resource group.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "api-version", valid_568233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_MediaServiceListByResourceGroup_568228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the Media Services in a resource group.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_MediaServiceListByResourceGroup_568228;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## mediaServiceListByResourceGroup
  ## Lists all of the Media Services in a resource group.
  ## https://aka.ms/media-manage
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  add(path_568236, "resourceGroupName", newJString(resourceGroupName))
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "subscriptionId", newJString(subscriptionId))
  result = call_568235.call(path_568236, query_568237, nil, nil, nil)

var mediaServiceListByResourceGroup* = Call_MediaServiceListByResourceGroup_568228(
    name: "mediaServiceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices",
    validator: validate_MediaServiceListByResourceGroup_568229, base: "",
    url: url_MediaServiceListByResourceGroup_568230, schemes: {Scheme.Https})
type
  Call_MediaServiceCreate_568249 = ref object of OpenApiRestCall_567658
proc url_MediaServiceCreate_568251(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "mediaServiceName" in path,
        "`mediaServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "mediaServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceCreate_568250(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("mediaServiceName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "mediaServiceName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Media Service properties needed for creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_MediaServiceCreate_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_MediaServiceCreate_568249; resourceGroupName: string;
          apiVersion: string; mediaServiceName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## mediaServiceCreate
  ## Creates a Media Service.
  ## https://aka.ms/media-manage
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   parameters: JObject (required)
  ##             : Media Service properties needed for creation.
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  var body_568261 = newJObject()
  add(path_568259, "resourceGroupName", newJString(resourceGroupName))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "mediaServiceName", newJString(mediaServiceName))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568261 = parameters
  result = call_568258.call(path_568259, query_568260, nil, nil, body_568261)

var mediaServiceCreate* = Call_MediaServiceCreate_568249(
    name: "mediaServiceCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}",
    validator: validate_MediaServiceCreate_568250, base: "",
    url: url_MediaServiceCreate_568251, schemes: {Scheme.Https})
type
  Call_MediaServiceGet_568238 = ref object of OpenApiRestCall_567658
proc url_MediaServiceGet_568240(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "mediaServiceName" in path,
        "`mediaServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "mediaServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceGet_568239(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("mediaServiceName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "mediaServiceName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_MediaServiceGet_568238; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_MediaServiceGet_568238; resourceGroupName: string;
          apiVersion: string; mediaServiceName: string; subscriptionId: string): Recallable =
  ## mediaServiceGet
  ## Gets a Media Service.
  ## https://aka.ms/media-manage
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "mediaServiceName", newJString(mediaServiceName))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var mediaServiceGet* = Call_MediaServiceGet_568238(name: "mediaServiceGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}",
    validator: validate_MediaServiceGet_568239, base: "", url: url_MediaServiceGet_568240,
    schemes: {Scheme.Https})
type
  Call_MediaServiceUpdate_568273 = ref object of OpenApiRestCall_567658
proc url_MediaServiceUpdate_568275(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "mediaServiceName" in path,
        "`mediaServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "mediaServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceUpdate_568274(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("mediaServiceName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "mediaServiceName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568279 = query.getOrDefault("api-version")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "api-version", valid_568279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Media Service properties needed for update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_MediaServiceUpdate_568273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_MediaServiceUpdate_568273; resourceGroupName: string;
          apiVersion: string; mediaServiceName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## mediaServiceUpdate
  ## Updates a Media Service.
  ## https://aka.ms/media-manage
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   parameters: JObject (required)
  ##             : Media Service properties needed for update.
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  var body_568285 = newJObject()
  add(path_568283, "resourceGroupName", newJString(resourceGroupName))
  add(query_568284, "api-version", newJString(apiVersion))
  add(path_568283, "mediaServiceName", newJString(mediaServiceName))
  add(path_568283, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568285 = parameters
  result = call_568282.call(path_568283, query_568284, nil, nil, body_568285)

var mediaServiceUpdate* = Call_MediaServiceUpdate_568273(
    name: "mediaServiceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}",
    validator: validate_MediaServiceUpdate_568274, base: "",
    url: url_MediaServiceUpdate_568275, schemes: {Scheme.Https})
type
  Call_MediaServiceDelete_568262 = ref object of OpenApiRestCall_567658
proc url_MediaServiceDelete_568264(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "mediaServiceName" in path,
        "`mediaServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "mediaServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceDelete_568263(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568265 = path.getOrDefault("resourceGroupName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "resourceGroupName", valid_568265
  var valid_568266 = path.getOrDefault("mediaServiceName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "mediaServiceName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568268 = query.getOrDefault("api-version")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "api-version", valid_568268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_MediaServiceDelete_568262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_MediaServiceDelete_568262; resourceGroupName: string;
          apiVersion: string; mediaServiceName: string; subscriptionId: string): Recallable =
  ## mediaServiceDelete
  ## Deletes a Media Service.
  ## https://aka.ms/media-manage
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  var path_568271 = newJObject()
  var query_568272 = newJObject()
  add(path_568271, "resourceGroupName", newJString(resourceGroupName))
  add(query_568272, "api-version", newJString(apiVersion))
  add(path_568271, "mediaServiceName", newJString(mediaServiceName))
  add(path_568271, "subscriptionId", newJString(subscriptionId))
  result = call_568270.call(path_568271, query_568272, nil, nil, nil)

var mediaServiceDelete* = Call_MediaServiceDelete_568262(
    name: "mediaServiceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}",
    validator: validate_MediaServiceDelete_568263, base: "",
    url: url_MediaServiceDelete_568264, schemes: {Scheme.Https})
type
  Call_MediaServiceListKeys_568286 = ref object of OpenApiRestCall_567658
proc url_MediaServiceListKeys_568288(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "mediaServiceName" in path,
        "`mediaServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "mediaServiceName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceListKeys_568287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the keys for a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568289 = path.getOrDefault("resourceGroupName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "resourceGroupName", valid_568289
  var valid_568290 = path.getOrDefault("mediaServiceName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "mediaServiceName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568292 = query.getOrDefault("api-version")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "api-version", valid_568292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_MediaServiceListKeys_568286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the keys for a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_MediaServiceListKeys_568286;
          resourceGroupName: string; apiVersion: string; mediaServiceName: string;
          subscriptionId: string): Recallable =
  ## mediaServiceListKeys
  ## Lists the keys for a Media Service.
  ## https://aka.ms/media-manage
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  add(path_568295, "resourceGroupName", newJString(resourceGroupName))
  add(query_568296, "api-version", newJString(apiVersion))
  add(path_568295, "mediaServiceName", newJString(mediaServiceName))
  add(path_568295, "subscriptionId", newJString(subscriptionId))
  result = call_568294.call(path_568295, query_568296, nil, nil, nil)

var mediaServiceListKeys* = Call_MediaServiceListKeys_568286(
    name: "mediaServiceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}/listKeys",
    validator: validate_MediaServiceListKeys_568287, base: "",
    url: url_MediaServiceListKeys_568288, schemes: {Scheme.Https})
type
  Call_MediaServiceRegenerateKey_568297 = ref object of OpenApiRestCall_567658
proc url_MediaServiceRegenerateKey_568299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "mediaServiceName" in path,
        "`mediaServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "mediaServiceName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceRegenerateKey_568298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates a primary or secondary key for a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568300 = path.getOrDefault("resourceGroupName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceGroupName", valid_568300
  var valid_568301 = path.getOrDefault("mediaServiceName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "mediaServiceName", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties needed to regenerate the Media Service key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_MediaServiceRegenerateKey_568297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates a primary or secondary key for a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_MediaServiceRegenerateKey_568297;
          resourceGroupName: string; apiVersion: string; mediaServiceName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## mediaServiceRegenerateKey
  ## Regenerates a primary or secondary key for a Media Service.
  ## https://aka.ms/media-manage
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   parameters: JObject (required)
  ##             : Properties needed to regenerate the Media Service key.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  var body_568309 = newJObject()
  add(path_568307, "resourceGroupName", newJString(resourceGroupName))
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "mediaServiceName", newJString(mediaServiceName))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568309 = parameters
  result = call_568306.call(path_568307, query_568308, nil, nil, body_568309)

var mediaServiceRegenerateKey* = Call_MediaServiceRegenerateKey_568297(
    name: "mediaServiceRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}/regenerateKey",
    validator: validate_MediaServiceRegenerateKey_568298, base: "",
    url: url_MediaServiceRegenerateKey_568299, schemes: {Scheme.Https})
type
  Call_MediaServiceSyncStorageKeys_568310 = ref object of OpenApiRestCall_567658
proc url_MediaServiceSyncStorageKeys_568312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "mediaServiceName" in path,
        "`mediaServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "mediaServiceName"),
               (kind: ConstantSegment, value: "/syncStorageKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MediaServiceSyncStorageKeys_568311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronizes storage account keys for a storage account associated with the Media Service account.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("mediaServiceName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "mediaServiceName", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "api-version", valid_568316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties needed to synchronize the keys for a storage account to the Media Service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_MediaServiceSyncStorageKeys_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Synchronizes storage account keys for a storage account associated with the Media Service account.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_MediaServiceSyncStorageKeys_568310;
          resourceGroupName: string; apiVersion: string; mediaServiceName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## mediaServiceSyncStorageKeys
  ## Synchronizes storage account keys for a storage account associated with the Media Service account.
  ## https://aka.ms/media-manage
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   parameters: JObject (required)
  ##             : Properties needed to synchronize the keys for a storage account to the Media Service.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  var body_568322 = newJObject()
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "mediaServiceName", newJString(mediaServiceName))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568322 = parameters
  result = call_568319.call(path_568320, query_568321, nil, nil, body_568322)

var mediaServiceSyncStorageKeys* = Call_MediaServiceSyncStorageKeys_568310(
    name: "mediaServiceSyncStorageKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}/syncStorageKeys",
    validator: validate_MediaServiceSyncStorageKeys_568311, base: "",
    url: url_MediaServiceSyncStorageKeys_568312, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
