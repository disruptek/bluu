
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_DeviceSecurityGroupsList_593646 = ref object of OpenApiRestCall_593424
proc url_DeviceSecurityGroupsList_593648(protocol: Scheme; host: string;
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

proc validate_DeviceSecurityGroupsList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593808 = path.getOrDefault("resourceId")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "resourceId", valid_593808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593809 = query.getOrDefault("api-version")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "api-version", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593836: Call_DeviceSecurityGroupsList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of device security groups for the specified IoT hub resource.
  ## 
  let valid = call_593836.validator(path, query, header, formData, body)
  let scheme = call_593836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593836.url(scheme.get, call_593836.host, call_593836.base,
                         call_593836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593836, url, valid)

proc call*(call_593907: Call_DeviceSecurityGroupsList_593646; apiVersion: string;
          resourceId: string): Recallable =
  ## deviceSecurityGroupsList
  ## Gets the list of device security groups for the specified IoT hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_593908 = newJObject()
  var query_593910 = newJObject()
  add(query_593910, "api-version", newJString(apiVersion))
  add(path_593908, "resourceId", newJString(resourceId))
  result = call_593907.call(path_593908, query_593910, nil, nil, nil)

var deviceSecurityGroupsList* = Call_DeviceSecurityGroupsList_593646(
    name: "deviceSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups",
    validator: validate_DeviceSecurityGroupsList_593647, base: "",
    url: url_DeviceSecurityGroupsList_593648, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsCreateOrUpdate_593968 = ref object of OpenApiRestCall_593424
proc url_DeviceSecurityGroupsCreateOrUpdate_593970(protocol: Scheme; host: string;
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

proc validate_DeviceSecurityGroupsCreateOrUpdate_593969(path: JsonNode;
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
  var valid_593971 = path.getOrDefault("resourceId")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceId", valid_593971
  var valid_593972 = path.getOrDefault("deviceSecurityGroupName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "deviceSecurityGroupName", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
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

proc call*(call_593975: Call_DeviceSecurityGroupsCreateOrUpdate_593968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the device security group on a specified IoT hub resource.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_DeviceSecurityGroupsCreateOrUpdate_593968;
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
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  var body_593979 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  if deviceSecurityGroup != nil:
    body_593979 = deviceSecurityGroup
  add(path_593977, "resourceId", newJString(resourceId))
  add(path_593977, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_593976.call(path_593977, query_593978, nil, nil, body_593979)

var deviceSecurityGroupsCreateOrUpdate* = Call_DeviceSecurityGroupsCreateOrUpdate_593968(
    name: "deviceSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsCreateOrUpdate_593969, base: "",
    url: url_DeviceSecurityGroupsCreateOrUpdate_593970, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsGet_593949 = ref object of OpenApiRestCall_593424
proc url_DeviceSecurityGroupsGet_593951(protocol: Scheme; host: string; base: string;
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

proc validate_DeviceSecurityGroupsGet_593950(path: JsonNode; query: JsonNode;
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
  var valid_593961 = path.getOrDefault("resourceId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "resourceId", valid_593961
  var valid_593962 = path.getOrDefault("deviceSecurityGroupName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "deviceSecurityGroupName", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_DeviceSecurityGroupsGet_593949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the device security group for the specified IoT hub resource.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_DeviceSecurityGroupsGet_593949; apiVersion: string;
          resourceId: string; deviceSecurityGroupName: string): Recallable =
  ## deviceSecurityGroupsGet
  ## Gets the device security group for the specified IoT hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "resourceId", newJString(resourceId))
  add(path_593966, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var deviceSecurityGroupsGet* = Call_DeviceSecurityGroupsGet_593949(
    name: "deviceSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsGet_593950, base: "",
    url: url_DeviceSecurityGroupsGet_593951, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsDelete_593980 = ref object of OpenApiRestCall_593424
proc url_DeviceSecurityGroupsDelete_593982(protocol: Scheme; host: string;
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

proc validate_DeviceSecurityGroupsDelete_593981(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("resourceId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "resourceId", valid_593983
  var valid_593984 = path.getOrDefault("deviceSecurityGroupName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "deviceSecurityGroupName", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_DeviceSecurityGroupsDelete_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the security group
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_DeviceSecurityGroupsDelete_593980; apiVersion: string;
          resourceId: string; deviceSecurityGroupName: string): Recallable =
  ## deviceSecurityGroupsDelete
  ## Deletes the security group
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the security group. Please notice that the name is case insensitive.
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "resourceId", newJString(resourceId))
  add(path_593988, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var deviceSecurityGroupsDelete* = Call_DeviceSecurityGroupsDelete_593980(
    name: "deviceSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsDelete_593981, base: "",
    url: url_DeviceSecurityGroupsDelete_593982, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
