
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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
  macServiceName = "security-deviceSecurityGroups"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeviceSecurityGroupsList_563777 = ref object of OpenApiRestCall_563555
proc url_DeviceSecurityGroupsList_563779(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/deviceSecurityGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSecurityGroupsList_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of device security groups for the specified IoT hub resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_563941 = path.getOrDefault("resourceId")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "resourceId", valid_563941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563942 = query.getOrDefault("api-version")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "api-version", valid_563942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563969: Call_DeviceSecurityGroupsList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of device security groups for the specified IoT hub resource.
  ## 
  let valid = call_563969.validator(path, query, header, formData, body)
  let scheme = call_563969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563969.url(scheme.get, call_563969.host, call_563969.base,
                         call_563969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563969, url, valid)

proc call*(call_564040: Call_DeviceSecurityGroupsList_563777; apiVersion: string;
          resourceId: string): Recallable =
  ## deviceSecurityGroupsList
  ## Gets the list of device security groups for the specified IoT hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_564041 = newJObject()
  var query_564043 = newJObject()
  add(query_564043, "api-version", newJString(apiVersion))
  add(path_564041, "resourceId", newJString(resourceId))
  result = call_564040.call(path_564041, query_564043, nil, nil, nil)

var deviceSecurityGroupsList* = Call_DeviceSecurityGroupsList_563777(
    name: "deviceSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups",
    validator: validate_DeviceSecurityGroupsList_563778, base: "",
    url: url_DeviceSecurityGroupsList_563779, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsCreateOrUpdate_564101 = ref object of OpenApiRestCall_563555
proc url_DeviceSecurityGroupsCreateOrUpdate_564103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "deviceSecurityGroupName" in path,
        "`deviceSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/deviceSecurityGroups/"),
               (kind: VariableSegment, value: "deviceSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSecurityGroupsCreateOrUpdate_564102(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the device security group on a specified IoT hub resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceSecurityGroupName` field"
  var valid_564104 = path.getOrDefault("deviceSecurityGroupName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "deviceSecurityGroupName", valid_564104
  var valid_564105 = path.getOrDefault("resourceId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "resourceId", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   deviceSecurityGroup: JObject (required)
  ##                      : Security group object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_DeviceSecurityGroupsCreateOrUpdate_564101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the device security group on a specified IoT hub resource.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_DeviceSecurityGroupsCreateOrUpdate_564101;
          deviceSecurityGroupName: string; apiVersion: string;
          deviceSecurityGroup: JsonNode; resourceId: string): Recallable =
  ## deviceSecurityGroupsCreateOrUpdate
  ## Creates or updates the device security group on a specified IoT hub resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   deviceSecurityGroup: JObject (required)
  ##                      : Security group object.
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  var body_564112 = newJObject()
  add(path_564110, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  add(query_564111, "api-version", newJString(apiVersion))
  if deviceSecurityGroup != nil:
    body_564112 = deviceSecurityGroup
  add(path_564110, "resourceId", newJString(resourceId))
  result = call_564109.call(path_564110, query_564111, nil, nil, body_564112)

var deviceSecurityGroupsCreateOrUpdate* = Call_DeviceSecurityGroupsCreateOrUpdate_564101(
    name: "deviceSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsCreateOrUpdate_564102, base: "",
    url: url_DeviceSecurityGroupsCreateOrUpdate_564103, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsGet_564082 = ref object of OpenApiRestCall_563555
proc url_DeviceSecurityGroupsGet_564084(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "deviceSecurityGroupName" in path,
        "`deviceSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/deviceSecurityGroups/"),
               (kind: VariableSegment, value: "deviceSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSecurityGroupsGet_564083(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the device security group for the specified IoT hub resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceSecurityGroupName` field"
  var valid_564094 = path.getOrDefault("deviceSecurityGroupName")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "deviceSecurityGroupName", valid_564094
  var valid_564095 = path.getOrDefault("resourceId")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceId", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_DeviceSecurityGroupsGet_564082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the device security group for the specified IoT hub resource.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_DeviceSecurityGroupsGet_564082;
          deviceSecurityGroupName: string; apiVersion: string; resourceId: string): Recallable =
  ## deviceSecurityGroupsGet
  ## Gets the device security group for the specified IoT hub resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(path_564099, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "resourceId", newJString(resourceId))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var deviceSecurityGroupsGet* = Call_DeviceSecurityGroupsGet_564082(
    name: "deviceSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsGet_564083, base: "",
    url: url_DeviceSecurityGroupsGet_564084, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsDelete_564113 = ref object of OpenApiRestCall_563555
proc url_DeviceSecurityGroupsDelete_564115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "deviceSecurityGroupName" in path,
        "`deviceSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/deviceSecurityGroups/"),
               (kind: VariableSegment, value: "deviceSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSecurityGroupsDelete_564114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the security group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceSecurityGroupName` field"
  var valid_564116 = path.getOrDefault("deviceSecurityGroupName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "deviceSecurityGroupName", valid_564116
  var valid_564117 = path.getOrDefault("resourceId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceId", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564118 = query.getOrDefault("api-version")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "api-version", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_DeviceSecurityGroupsDelete_564113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the security group
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_DeviceSecurityGroupsDelete_564113;
          deviceSecurityGroupName: string; apiVersion: string; resourceId: string): Recallable =
  ## deviceSecurityGroupsDelete
  ## Deletes the security group
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(path_564121, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  add(query_564122, "api-version", newJString(apiVersion))
  add(path_564121, "resourceId", newJString(resourceId))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var deviceSecurityGroupsDelete* = Call_DeviceSecurityGroupsDelete_564113(
    name: "deviceSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsDelete_564114, base: "",
    url: url_DeviceSecurityGroupsDelete_564115, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
