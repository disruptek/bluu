
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "mediaservices-media"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
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
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Media Services REST API operations.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Media Services REST API operations.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Media/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_MediaServiceCheckNameAvailability_564076 = ref object of OpenApiRestCall_563556
proc url_MediaServiceCheckNameAvailability_564078(protocol: Scheme; host: string;
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

proc validate_MediaServiceCheckNameAvailability_564077(path: JsonNode;
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
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
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

proc call*(call_564123: Call_MediaServiceCheckNameAvailability_564076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the Media Service resource name is available. The name must be globally unique.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_MediaServiceCheckNameAvailability_564076;
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
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  var body_564127 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564127 = parameters
  result = call_564124.call(path_564125, query_564126, nil, nil, body_564127)

var mediaServiceCheckNameAvailability* = Call_MediaServiceCheckNameAvailability_564076(
    name: "mediaServiceCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Media/CheckNameAvailability",
    validator: validate_MediaServiceCheckNameAvailability_564077, base: "",
    url: url_MediaServiceCheckNameAvailability_564078, schemes: {Scheme.Https})
type
  Call_MediaServiceListByResourceGroup_564128 = ref object of OpenApiRestCall_563556
proc url_MediaServiceListByResourceGroup_564130(protocol: Scheme; host: string;
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

proc validate_MediaServiceListByResourceGroup_564129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the Media Services in a resource group.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  var valid_564132 = path.getOrDefault("resourceGroupName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "resourceGroupName", valid_564132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564133 = query.getOrDefault("api-version")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "api-version", valid_564133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564134: Call_MediaServiceListByResourceGroup_564128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the Media Services in a resource group.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564134.validator(path, query, header, formData, body)
  let scheme = call_564134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564134.url(scheme.get, call_564134.host, call_564134.base,
                         call_564134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564134, url, valid)

proc call*(call_564135: Call_MediaServiceListByResourceGroup_564128;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## mediaServiceListByResourceGroup
  ## Lists all of the Media Services in a resource group.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564136 = newJObject()
  var query_564137 = newJObject()
  add(query_564137, "api-version", newJString(apiVersion))
  add(path_564136, "subscriptionId", newJString(subscriptionId))
  add(path_564136, "resourceGroupName", newJString(resourceGroupName))
  result = call_564135.call(path_564136, query_564137, nil, nil, nil)

var mediaServiceListByResourceGroup* = Call_MediaServiceListByResourceGroup_564128(
    name: "mediaServiceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices",
    validator: validate_MediaServiceListByResourceGroup_564129, base: "",
    url: url_MediaServiceListByResourceGroup_564130, schemes: {Scheme.Https})
type
  Call_MediaServiceCreate_564149 = ref object of OpenApiRestCall_563556
proc url_MediaServiceCreate_564151(protocol: Scheme; host: string; base: string;
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

proc validate_MediaServiceCreate_564150(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("mediaServiceName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "mediaServiceName", valid_564153
  var valid_564154 = path.getOrDefault("resourceGroupName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "resourceGroupName", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
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

proc call*(call_564157: Call_MediaServiceCreate_564149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_MediaServiceCreate_564149; apiVersion: string;
          subscriptionId: string; mediaServiceName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## mediaServiceCreate
  ## Creates a Media Service.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Media Service properties needed for creation.
  var path_564159 = newJObject()
  var query_564160 = newJObject()
  var body_564161 = newJObject()
  add(query_564160, "api-version", newJString(apiVersion))
  add(path_564159, "subscriptionId", newJString(subscriptionId))
  add(path_564159, "mediaServiceName", newJString(mediaServiceName))
  add(path_564159, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564161 = parameters
  result = call_564158.call(path_564159, query_564160, nil, nil, body_564161)

var mediaServiceCreate* = Call_MediaServiceCreate_564149(
    name: "mediaServiceCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}",
    validator: validate_MediaServiceCreate_564150, base: "",
    url: url_MediaServiceCreate_564151, schemes: {Scheme.Https})
type
  Call_MediaServiceGet_564138 = ref object of OpenApiRestCall_563556
proc url_MediaServiceGet_564140(protocol: Scheme; host: string; base: string;
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

proc validate_MediaServiceGet_564139(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("mediaServiceName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "mediaServiceName", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564144 = query.getOrDefault("api-version")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "api-version", valid_564144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_MediaServiceGet_564138; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_MediaServiceGet_564138; apiVersion: string;
          subscriptionId: string; mediaServiceName: string;
          resourceGroupName: string): Recallable =
  ## mediaServiceGet
  ## Gets a Media Service.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  add(path_564147, "mediaServiceName", newJString(mediaServiceName))
  add(path_564147, "resourceGroupName", newJString(resourceGroupName))
  result = call_564146.call(path_564147, query_564148, nil, nil, nil)

var mediaServiceGet* = Call_MediaServiceGet_564138(name: "mediaServiceGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}",
    validator: validate_MediaServiceGet_564139, base: "", url: url_MediaServiceGet_564140,
    schemes: {Scheme.Https})
type
  Call_MediaServiceUpdate_564173 = ref object of OpenApiRestCall_563556
proc url_MediaServiceUpdate_564175(protocol: Scheme; host: string; base: string;
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

proc validate_MediaServiceUpdate_564174(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564176 = path.getOrDefault("subscriptionId")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "subscriptionId", valid_564176
  var valid_564177 = path.getOrDefault("mediaServiceName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "mediaServiceName", valid_564177
  var valid_564178 = path.getOrDefault("resourceGroupName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "resourceGroupName", valid_564178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564179 = query.getOrDefault("api-version")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "api-version", valid_564179
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

proc call*(call_564181: Call_MediaServiceUpdate_564173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_MediaServiceUpdate_564173; apiVersion: string;
          subscriptionId: string; mediaServiceName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## mediaServiceUpdate
  ## Updates a Media Service.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Media Service properties needed for update.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  var body_564185 = newJObject()
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "subscriptionId", newJString(subscriptionId))
  add(path_564183, "mediaServiceName", newJString(mediaServiceName))
  add(path_564183, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564185 = parameters
  result = call_564182.call(path_564183, query_564184, nil, nil, body_564185)

var mediaServiceUpdate* = Call_MediaServiceUpdate_564173(
    name: "mediaServiceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}",
    validator: validate_MediaServiceUpdate_564174, base: "",
    url: url_MediaServiceUpdate_564175, schemes: {Scheme.Https})
type
  Call_MediaServiceDelete_564162 = ref object of OpenApiRestCall_563556
proc url_MediaServiceDelete_564164(protocol: Scheme; host: string; base: string;
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

proc validate_MediaServiceDelete_564163(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564165 = path.getOrDefault("subscriptionId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "subscriptionId", valid_564165
  var valid_564166 = path.getOrDefault("mediaServiceName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "mediaServiceName", valid_564166
  var valid_564167 = path.getOrDefault("resourceGroupName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "resourceGroupName", valid_564167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564168 = query.getOrDefault("api-version")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "api-version", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_MediaServiceDelete_564162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_MediaServiceDelete_564162; apiVersion: string;
          subscriptionId: string; mediaServiceName: string;
          resourceGroupName: string): Recallable =
  ## mediaServiceDelete
  ## Deletes a Media Service.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  add(query_564172, "api-version", newJString(apiVersion))
  add(path_564171, "subscriptionId", newJString(subscriptionId))
  add(path_564171, "mediaServiceName", newJString(mediaServiceName))
  add(path_564171, "resourceGroupName", newJString(resourceGroupName))
  result = call_564170.call(path_564171, query_564172, nil, nil, nil)

var mediaServiceDelete* = Call_MediaServiceDelete_564162(
    name: "mediaServiceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}",
    validator: validate_MediaServiceDelete_564163, base: "",
    url: url_MediaServiceDelete_564164, schemes: {Scheme.Https})
type
  Call_MediaServiceListKeys_564186 = ref object of OpenApiRestCall_563556
proc url_MediaServiceListKeys_564188(protocol: Scheme; host: string; base: string;
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

proc validate_MediaServiceListKeys_564187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the keys for a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("mediaServiceName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "mediaServiceName", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "api-version", valid_564192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_MediaServiceListKeys_564186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the keys for a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_MediaServiceListKeys_564186; apiVersion: string;
          subscriptionId: string; mediaServiceName: string;
          resourceGroupName: string): Recallable =
  ## mediaServiceListKeys
  ## Lists the keys for a Media Service.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "mediaServiceName", newJString(mediaServiceName))
  add(path_564195, "resourceGroupName", newJString(resourceGroupName))
  result = call_564194.call(path_564195, query_564196, nil, nil, nil)

var mediaServiceListKeys* = Call_MediaServiceListKeys_564186(
    name: "mediaServiceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}/listKeys",
    validator: validate_MediaServiceListKeys_564187, base: "",
    url: url_MediaServiceListKeys_564188, schemes: {Scheme.Https})
type
  Call_MediaServiceRegenerateKey_564197 = ref object of OpenApiRestCall_563556
proc url_MediaServiceRegenerateKey_564199(protocol: Scheme; host: string;
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

proc validate_MediaServiceRegenerateKey_564198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates a primary or secondary key for a Media Service.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564200 = path.getOrDefault("subscriptionId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "subscriptionId", valid_564200
  var valid_564201 = path.getOrDefault("mediaServiceName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "mediaServiceName", valid_564201
  var valid_564202 = path.getOrDefault("resourceGroupName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "resourceGroupName", valid_564202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564203 = query.getOrDefault("api-version")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "api-version", valid_564203
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

proc call*(call_564205: Call_MediaServiceRegenerateKey_564197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates a primary or secondary key for a Media Service.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_MediaServiceRegenerateKey_564197; apiVersion: string;
          subscriptionId: string; mediaServiceName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## mediaServiceRegenerateKey
  ## Regenerates a primary or secondary key for a Media Service.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Properties needed to regenerate the Media Service key.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  var body_564209 = newJObject()
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "mediaServiceName", newJString(mediaServiceName))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564209 = parameters
  result = call_564206.call(path_564207, query_564208, nil, nil, body_564209)

var mediaServiceRegenerateKey* = Call_MediaServiceRegenerateKey_564197(
    name: "mediaServiceRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}/regenerateKey",
    validator: validate_MediaServiceRegenerateKey_564198, base: "",
    url: url_MediaServiceRegenerateKey_564199, schemes: {Scheme.Https})
type
  Call_MediaServiceSyncStorageKeys_564210 = ref object of OpenApiRestCall_563556
proc url_MediaServiceSyncStorageKeys_564212(protocol: Scheme; host: string;
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

proc validate_MediaServiceSyncStorageKeys_564211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronizes storage account keys for a storage account associated with the Media Service account.
  ## 
  ## https://aka.ms/media-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: JString (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("mediaServiceName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "mediaServiceName", valid_564214
  var valid_564215 = path.getOrDefault("resourceGroupName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceGroupName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "api-version", valid_564216
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

proc call*(call_564218: Call_MediaServiceSyncStorageKeys_564210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Synchronizes storage account keys for a storage account associated with the Media Service account.
  ## 
  ## https://aka.ms/media-manage
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_MediaServiceSyncStorageKeys_564210;
          apiVersion: string; subscriptionId: string; mediaServiceName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## mediaServiceSyncStorageKeys
  ## Synchronizes storage account keys for a storage account associated with the Media Service account.
  ## https://aka.ms/media-manage
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-10-01.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   mediaServiceName: string (required)
  ##                   : Name of the Media Service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Properties needed to synchronize the keys for a storage account to the Media Service.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  var body_564222 = newJObject()
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "mediaServiceName", newJString(mediaServiceName))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564222 = parameters
  result = call_564219.call(path_564220, query_564221, nil, nil, body_564222)

var mediaServiceSyncStorageKeys* = Call_MediaServiceSyncStorageKeys_564210(
    name: "mediaServiceSyncStorageKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{mediaServiceName}/syncStorageKeys",
    validator: validate_MediaServiceSyncStorageKeys_564211, base: "",
    url: url_MediaServiceSyncStorageKeys_564212, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
