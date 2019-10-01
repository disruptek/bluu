
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "security-deviceSecurityGroups"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeviceSecurityGroupsList_567879 = ref object of OpenApiRestCall_567657
proc url_DeviceSecurityGroupsList_567881(protocol: Scheme; host: string;
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

proc validate_DeviceSecurityGroupsList_567880(path: JsonNode; query: JsonNode;
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
  var valid_568041 = path.getOrDefault("resourceId")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "resourceId", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568069: Call_DeviceSecurityGroupsList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of device security groups for the specified IoT hub resource.
  ## 
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_DeviceSecurityGroupsList_567879; apiVersion: string;
          resourceId: string): Recallable =
  ## deviceSecurityGroupsList
  ## Gets the list of device security groups for the specified IoT hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_568141 = newJObject()
  var query_568143 = newJObject()
  add(query_568143, "api-version", newJString(apiVersion))
  add(path_568141, "resourceId", newJString(resourceId))
  result = call_568140.call(path_568141, query_568143, nil, nil, nil)

var deviceSecurityGroupsList* = Call_DeviceSecurityGroupsList_567879(
    name: "deviceSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups",
    validator: validate_DeviceSecurityGroupsList_567880, base: "",
    url: url_DeviceSecurityGroupsList_567881, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsCreateOrUpdate_568201 = ref object of OpenApiRestCall_567657
proc url_DeviceSecurityGroupsCreateOrUpdate_568203(protocol: Scheme; host: string;
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

proc validate_DeviceSecurityGroupsCreateOrUpdate_568202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the device security group on a specified IoT hub resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568204 = path.getOrDefault("resourceId")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "resourceId", valid_568204
  var valid_568205 = path.getOrDefault("deviceSecurityGroupName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "deviceSecurityGroupName", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
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

proc call*(call_568208: Call_DeviceSecurityGroupsCreateOrUpdate_568201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the device security group on a specified IoT hub resource.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_DeviceSecurityGroupsCreateOrUpdate_568201;
          apiVersion: string; deviceSecurityGroup: JsonNode; resourceId: string;
          deviceSecurityGroupName: string): Recallable =
  ## deviceSecurityGroupsCreateOrUpdate
  ## Creates or updates the device security group on a specified IoT hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   deviceSecurityGroup: JObject (required)
  ##                      : Security group object.
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  var body_568212 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  if deviceSecurityGroup != nil:
    body_568212 = deviceSecurityGroup
  add(path_568210, "resourceId", newJString(resourceId))
  add(path_568210, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_568209.call(path_568210, query_568211, nil, nil, body_568212)

var deviceSecurityGroupsCreateOrUpdate* = Call_DeviceSecurityGroupsCreateOrUpdate_568201(
    name: "deviceSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsCreateOrUpdate_568202, base: "",
    url: url_DeviceSecurityGroupsCreateOrUpdate_568203, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsGet_568182 = ref object of OpenApiRestCall_567657
proc url_DeviceSecurityGroupsGet_568184(protocol: Scheme; host: string; base: string;
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

proc validate_DeviceSecurityGroupsGet_568183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the device security group for the specified IoT hub resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568194 = path.getOrDefault("resourceId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "resourceId", valid_568194
  var valid_568195 = path.getOrDefault("deviceSecurityGroupName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "deviceSecurityGroupName", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_DeviceSecurityGroupsGet_568182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the device security group for the specified IoT hub resource.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_DeviceSecurityGroupsGet_568182; apiVersion: string;
          resourceId: string; deviceSecurityGroupName: string): Recallable =
  ## deviceSecurityGroupsGet
  ## Gets the device security group for the specified IoT hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "resourceId", newJString(resourceId))
  add(path_568199, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var deviceSecurityGroupsGet* = Call_DeviceSecurityGroupsGet_568182(
    name: "deviceSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsGet_568183, base: "",
    url: url_DeviceSecurityGroupsGet_568184, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsDelete_568213 = ref object of OpenApiRestCall_567657
proc url_DeviceSecurityGroupsDelete_568215(protocol: Scheme; host: string;
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

proc validate_DeviceSecurityGroupsDelete_568214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the security group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568216 = path.getOrDefault("resourceId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "resourceId", valid_568216
  var valid_568217 = path.getOrDefault("deviceSecurityGroupName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "deviceSecurityGroupName", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_DeviceSecurityGroupsDelete_568213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the security group
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_DeviceSecurityGroupsDelete_568213; apiVersion: string;
          resourceId: string; deviceSecurityGroupName: string): Recallable =
  ## deviceSecurityGroupsDelete
  ## Deletes the security group
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "resourceId", newJString(resourceId))
  add(path_568221, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var deviceSecurityGroupsDelete* = Call_DeviceSecurityGroupsDelete_568213(
    name: "deviceSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsDelete_568214, base: "",
    url: url_DeviceSecurityGroupsDelete_568215, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
