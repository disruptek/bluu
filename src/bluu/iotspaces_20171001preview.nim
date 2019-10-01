
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: IoTSpacesClient
## version: 2017-10-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use this API to manage the IoTSpaces service instances in your Azure subscription.
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "iotspaces"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available IoTSpaces service REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568053 = query.getOrDefault("api-version")
  valid_568053 = validateParameter(valid_568053, JString, required = true,
                                 default = newJString("2017-10-01-preview"))
  if valid_568053 != nil:
    section.add "api-version", valid_568053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568076: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available IoTSpaces service REST API operations.
  ## 
  let valid = call_568076.validator(path, query, header, formData, body)
  let scheme = call_568076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568076.url(scheme.get, call_568076.host, call_568076.base,
                         call_568076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568076, url, valid)

proc call*(call_568147: Call_OperationsList_567879;
          apiVersion: string = "2017-10-01-preview"): Recallable =
  ## operationsList
  ## Lists all of the available IoTSpaces service REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_568148 = newJObject()
  add(query_568148, "api-version", newJString(apiVersion))
  result = call_568147.call(nil, query_568148, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.IoTSpaces/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_IoTSpacesList_568188 = ref object of OpenApiRestCall_567657
proc url_IoTSpacesList_568190(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.IoTSpaces/Graph")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSpacesList_568189(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the IoTSpaces instances in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568205 = path.getOrDefault("subscriptionId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "subscriptionId", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = newJString("2017-10-01-preview"))
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_IoTSpacesList_568188; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the IoTSpaces instances in a subscription.
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_IoTSpacesList_568188; subscriptionId: string;
          apiVersion: string = "2017-10-01-preview"): Recallable =
  ## ioTSpacesList
  ## Get all the IoTSpaces instances in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var ioTSpacesList* = Call_IoTSpacesList_568188(name: "ioTSpacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.IoTSpaces/Graph",
    validator: validate_IoTSpacesList_568189, base: "", url: url_IoTSpacesList_568190,
    schemes: {Scheme.Https})
type
  Call_IoTSpacesCheckNameAvailability_568211 = ref object of OpenApiRestCall_567657
proc url_IoTSpacesCheckNameAvailability_568213(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.IoTSpaces/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSpacesCheckNameAvailability_568212(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if an IoTSpaces instance name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = newJString("2017-10-01-preview"))
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   operationInputs: JObject (required)
  ##                  : Set the name parameter in the OperationInputs structure to the name of the IoTSpaces instance to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_IoTSpacesCheckNameAvailability_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if an IoTSpaces instance name is available.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_IoTSpacesCheckNameAvailability_568211;
          subscriptionId: string; operationInputs: JsonNode;
          apiVersion: string = "2017-10-01-preview"): Recallable =
  ## ioTSpacesCheckNameAvailability
  ## Check if an IoTSpaces instance name is available.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   operationInputs: JObject (required)
  ##                  : Set the name parameter in the OperationInputs structure to the name of the IoTSpaces instance to check.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  var body_568221 = newJObject()
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  if operationInputs != nil:
    body_568221 = operationInputs
  result = call_568218.call(path_568219, query_568220, nil, nil, body_568221)

var ioTSpacesCheckNameAvailability* = Call_IoTSpacesCheckNameAvailability_568211(
    name: "ioTSpacesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.IoTSpaces/checkNameAvailability",
    validator: validate_IoTSpacesCheckNameAvailability_568212, base: "",
    url: url_IoTSpacesCheckNameAvailability_568213, schemes: {Scheme.Https})
type
  Call_IoTSpacesListByResourceGroup_568222 = ref object of OpenApiRestCall_567657
proc url_IoTSpacesListByResourceGroup_568224(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.IoTSpaces/Graph")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSpacesListByResourceGroup_568223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the IoTSpaces instances in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568225 = path.getOrDefault("resourceGroupName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "resourceGroupName", valid_568225
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = newJString("2017-10-01-preview"))
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_IoTSpacesListByResourceGroup_568222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the IoTSpaces instances in a resource group.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_IoTSpacesListByResourceGroup_568222;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2017-10-01-preview"): Recallable =
  ## ioTSpacesListByResourceGroup
  ## Get all the IoTSpaces instances in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var ioTSpacesListByResourceGroup* = Call_IoTSpacesListByResourceGroup_568222(
    name: "ioTSpacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTSpaces/Graph",
    validator: validate_IoTSpacesListByResourceGroup_568223, base: "",
    url: url_IoTSpacesListByResourceGroup_568224, schemes: {Scheme.Https})
type
  Call_IoTSpacesCreateOrUpdate_568243 = ref object of OpenApiRestCall_567657
proc url_IoTSpacesCreateOrUpdate_568245(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.IoTSpaces/Graph/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSpacesCreateOrUpdate_568244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the metadata of an IoTSpaces instance. The usual pattern to modify a property is to retrieve the IoTSpaces instance metadata and security metadata, and then combine them with the modified values in a new body to update the IoTSpaces instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoTSpaces instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  var valid_568248 = path.getOrDefault("resourceName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceName", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = newJString("2017-10-01-preview"))
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iotSpaceDescription: JObject (required)
  ##                      : The IoTSpaces instance metadata and security metadata.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_IoTSpacesCreateOrUpdate_568243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of an IoTSpaces instance. The usual pattern to modify a property is to retrieve the IoTSpaces instance metadata and security metadata, and then combine them with the modified values in a new body to update the IoTSpaces instance.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_IoTSpacesCreateOrUpdate_568243;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          iotSpaceDescription: JsonNode; apiVersion: string = "2017-10-01-preview"): Recallable =
  ## ioTSpacesCreateOrUpdate
  ## Create or update the metadata of an IoTSpaces instance. The usual pattern to modify a property is to retrieve the IoTSpaces instance metadata and security metadata, and then combine them with the modified values in a new body to update the IoTSpaces instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoTSpaces instance.
  ##   iotSpaceDescription: JObject (required)
  ##                      : The IoTSpaces instance metadata and security metadata.
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  var body_568255 = newJObject()
  add(path_568253, "resourceGroupName", newJString(resourceGroupName))
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  add(path_568253, "resourceName", newJString(resourceName))
  if iotSpaceDescription != nil:
    body_568255 = iotSpaceDescription
  result = call_568252.call(path_568253, query_568254, nil, nil, body_568255)

var ioTSpacesCreateOrUpdate* = Call_IoTSpacesCreateOrUpdate_568243(
    name: "ioTSpacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTSpaces/Graph/{resourceName}",
    validator: validate_IoTSpacesCreateOrUpdate_568244, base: "",
    url: url_IoTSpacesCreateOrUpdate_568245, schemes: {Scheme.Https})
type
  Call_IoTSpacesGet_568232 = ref object of OpenApiRestCall_567657
proc url_IoTSpacesGet_568234(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.IoTSpaces/Graph/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSpacesGet_568233(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the metadata of a IoTSpaces instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoTSpaces instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568235 = path.getOrDefault("resourceGroupName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "resourceGroupName", valid_568235
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  var valid_568237 = path.getOrDefault("resourceName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceName", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = newJString("2017-10-01-preview"))
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_IoTSpacesGet_568232; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metadata of a IoTSpaces instance.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_IoTSpacesGet_568232; resourceGroupName: string;
          subscriptionId: string; resourceName: string;
          apiVersion: string = "2017-10-01-preview"): Recallable =
  ## ioTSpacesGet
  ## Get the metadata of a IoTSpaces instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoTSpaces instance.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(path_568241, "resourceName", newJString(resourceName))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var ioTSpacesGet* = Call_IoTSpacesGet_568232(name: "ioTSpacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTSpaces/Graph/{resourceName}",
    validator: validate_IoTSpacesGet_568233, base: "", url: url_IoTSpacesGet_568234,
    schemes: {Scheme.Https})
type
  Call_IoTSpacesUpdate_568267 = ref object of OpenApiRestCall_567657
proc url_IoTSpacesUpdate_568269(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.IoTSpaces/Graph/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSpacesUpdate_568268(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Update the metadata of a IoTSpaces instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoTSpaces instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  var valid_568272 = path.getOrDefault("resourceName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceName", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = newJString("2017-10-01-preview"))
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iotSpacePatchDescription: JObject (required)
  ##                           : The IoTSpaces instance metadata and security metadata.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_IoTSpacesUpdate_568267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the metadata of a IoTSpaces instance.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_IoTSpacesUpdate_568267; resourceGroupName: string;
          subscriptionId: string; resourceName: string;
          iotSpacePatchDescription: JsonNode;
          apiVersion: string = "2017-10-01-preview"): Recallable =
  ## ioTSpacesUpdate
  ## Update the metadata of a IoTSpaces instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoTSpaces instance.
  ##   iotSpacePatchDescription: JObject (required)
  ##                           : The IoTSpaces instance metadata and security metadata.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  var body_568279 = newJObject()
  add(path_568277, "resourceGroupName", newJString(resourceGroupName))
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  add(path_568277, "resourceName", newJString(resourceName))
  if iotSpacePatchDescription != nil:
    body_568279 = iotSpacePatchDescription
  result = call_568276.call(path_568277, query_568278, nil, nil, body_568279)

var ioTSpacesUpdate* = Call_IoTSpacesUpdate_568267(name: "ioTSpacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTSpaces/Graph/{resourceName}",
    validator: validate_IoTSpacesUpdate_568268, base: "", url: url_IoTSpacesUpdate_568269,
    schemes: {Scheme.Https})
type
  Call_IoTSpacesDelete_568256 = ref object of OpenApiRestCall_567657
proc url_IoTSpacesDelete_568258(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.IoTSpaces/Graph/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSpacesDelete_568257(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete an IoTSpaces instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoTSpaces instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568259 = path.getOrDefault("resourceGroupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceGroupName", valid_568259
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  var valid_568261 = path.getOrDefault("resourceName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceName", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = newJString("2017-10-01-preview"))
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_IoTSpacesDelete_568256; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an IoTSpaces instance.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_IoTSpacesDelete_568256; resourceGroupName: string;
          subscriptionId: string; resourceName: string;
          apiVersion: string = "2017-10-01-preview"): Recallable =
  ## ioTSpacesDelete
  ## Delete an IoTSpaces instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoTSpaces instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoTSpaces instance.
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(path_568265, "resourceGroupName", newJString(resourceGroupName))
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "subscriptionId", newJString(subscriptionId))
  add(path_568265, "resourceName", newJString(resourceName))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var ioTSpacesDelete* = Call_IoTSpacesDelete_568256(name: "ioTSpacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTSpaces/Graph/{resourceName}",
    validator: validate_IoTSpacesDelete_568257, base: "", url: url_IoTSpacesDelete_568258,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
