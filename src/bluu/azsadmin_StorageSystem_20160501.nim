
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Storage system operation endpoints and objects.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-StorageSystem"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageSystemsList_563777 = ref object of OpenApiRestCall_563555
proc url_StorageSystemsList_563779(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/storageSubSystems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSystemsList_563778(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a list of all storage subsystems for a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563942 = path.getOrDefault("subscriptionId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "subscriptionId", valid_563942
  var valid_563943 = path.getOrDefault("location")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "location", valid_563943
  var valid_563944 = path.getOrDefault("resourceGroupName")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "resourceGroupName", valid_563944
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563958 = query.getOrDefault("api-version")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_563958 != nil:
    section.add "api-version", valid_563958
  var valid_563959 = query.getOrDefault("$filter")
  valid_563959 = validateParameter(valid_563959, JString, required = false,
                                 default = nil)
  if valid_563959 != nil:
    section.add "$filter", valid_563959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563986: Call_StorageSystemsList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all storage subsystems for a location.
  ## 
  let valid = call_563986.validator(path, query, header, formData, body)
  let scheme = call_563986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563986.url(scheme.get, call_563986.host, call_563986.base,
                         call_563986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563986, url, valid)

proc call*(call_564057: Call_StorageSystemsList_563777; subscriptionId: string;
          location: string; resourceGroupName: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## storageSystemsList
  ## Returns a list of all storage subsystems for a location.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_564058 = newJObject()
  var query_564060 = newJObject()
  add(query_564060, "api-version", newJString(apiVersion))
  add(path_564058, "subscriptionId", newJString(subscriptionId))
  add(path_564058, "location", newJString(location))
  add(path_564058, "resourceGroupName", newJString(resourceGroupName))
  add(query_564060, "$filter", newJString(Filter))
  result = call_564057.call(path_564058, query_564060, nil, nil, nil)

var storageSystemsList* = Call_StorageSystemsList_563777(
    name: "storageSystemsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/storageSubSystems",
    validator: validate_StorageSystemsList_563778, base: "",
    url: url_StorageSystemsList_563779, schemes: {Scheme.Https})
type
  Call_StorageSystemsGet_564099 = ref object of OpenApiRestCall_563555
proc url_StorageSystemsGet_564101(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "storageSubSystem" in path,
        "`storageSubSystem` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/storageSubSystems/"),
               (kind: VariableSegment, value: "storageSubSystem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSystemsGet_564100(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Return the requested storage subsystem.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   storageSubSystem: JString (required)
  ##                   : Name of the storage system.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564111 = path.getOrDefault("subscriptionId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "subscriptionId", valid_564111
  var valid_564112 = path.getOrDefault("location")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "location", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  var valid_564114 = path.getOrDefault("storageSubSystem")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "storageSubSystem", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_StorageSystemsGet_564099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the requested storage subsystem.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_StorageSystemsGet_564099; subscriptionId: string;
          location: string; resourceGroupName: string; storageSubSystem: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## storageSystemsGet
  ## Return the requested storage subsystem.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   storageSubSystem: string (required)
  ##                   : Name of the storage system.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "location", newJString(location))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  add(path_564118, "storageSubSystem", newJString(storageSubSystem))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var storageSystemsGet* = Call_StorageSystemsGet_564099(name: "storageSystemsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/storageSubSystems/{storageSubSystem}",
    validator: validate_StorageSystemsGet_564100, base: "",
    url: url_StorageSystemsGet_564101, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
