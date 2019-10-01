
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## IP pool operation endpoints and objects.
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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-IpPool"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IpPoolsList_574679 = ref object of OpenApiRestCall_574457
proc url_IpPoolsList_574681(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/ipPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IpPoolsList_574680(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of all IP pools at a certain location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574842 = path.getOrDefault("resourceGroupName")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "resourceGroupName", valid_574842
  var valid_574843 = path.getOrDefault("subscriptionId")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "subscriptionId", valid_574843
  var valid_574844 = path.getOrDefault("location")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "location", valid_574844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574858 = query.getOrDefault("api-version")
  valid_574858 = validateParameter(valid_574858, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574858 != nil:
    section.add "api-version", valid_574858
  var valid_574859 = query.getOrDefault("$filter")
  valid_574859 = validateParameter(valid_574859, JString, required = false,
                                 default = nil)
  if valid_574859 != nil:
    section.add "$filter", valid_574859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574886: Call_IpPoolsList_574679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all IP pools at a certain location.
  ## 
  let valid = call_574886.validator(path, query, header, formData, body)
  let scheme = call_574886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574886.url(scheme.get, call_574886.host, call_574886.base,
                         call_574886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574886, url, valid)

proc call*(call_574957: Call_IpPoolsList_574679; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## ipPoolsList
  ## Returns a list of all IP pools at a certain location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574958 = newJObject()
  var query_574960 = newJObject()
  add(path_574958, "resourceGroupName", newJString(resourceGroupName))
  add(query_574960, "api-version", newJString(apiVersion))
  add(path_574958, "subscriptionId", newJString(subscriptionId))
  add(path_574958, "location", newJString(location))
  add(query_574960, "$filter", newJString(Filter))
  result = call_574957.call(path_574958, query_574960, nil, nil, nil)

var ipPoolsList* = Call_IpPoolsList_574679(name: "ipPoolsList",
                                        meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/ipPools",
                                        validator: validate_IpPoolsList_574680,
                                        base: "", url: url_IpPoolsList_574681,
                                        schemes: {Scheme.Https})
type
  Call_IpPoolsCreateOrUpdate_575020 = ref object of OpenApiRestCall_574457
proc url_IpPoolsCreateOrUpdate_575022(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "ipPool" in path, "`ipPool` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/ipPools/"),
               (kind: VariableSegment, value: "ipPool")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IpPoolsCreateOrUpdate_575021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an IP pool.  Once created an IP pool cannot be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ipPool: JString (required)
  ##         : IP pool name.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575023 = path.getOrDefault("resourceGroupName")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "resourceGroupName", valid_575023
  var valid_575024 = path.getOrDefault("subscriptionId")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "subscriptionId", valid_575024
  var valid_575025 = path.getOrDefault("ipPool")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "ipPool", valid_575025
  var valid_575026 = path.getOrDefault("location")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "location", valid_575026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575027 = query.getOrDefault("api-version")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575027 != nil:
    section.add "api-version", valid_575027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pool: JObject (required)
  ##       : IP pool object to send.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575029: Call_IpPoolsCreateOrUpdate_575020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an IP pool.  Once created an IP pool cannot be deleted.
  ## 
  let valid = call_575029.validator(path, query, header, formData, body)
  let scheme = call_575029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575029.url(scheme.get, call_575029.host, call_575029.base,
                         call_575029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575029, url, valid)

proc call*(call_575030: Call_IpPoolsCreateOrUpdate_575020; pool: JsonNode;
          resourceGroupName: string; subscriptionId: string; ipPool: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## ipPoolsCreateOrUpdate
  ## Create an IP pool.  Once created an IP pool cannot be deleted.
  ##   pool: JObject (required)
  ##       : IP pool object to send.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ipPool: string (required)
  ##         : IP pool name.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575031 = newJObject()
  var query_575032 = newJObject()
  var body_575033 = newJObject()
  if pool != nil:
    body_575033 = pool
  add(path_575031, "resourceGroupName", newJString(resourceGroupName))
  add(query_575032, "api-version", newJString(apiVersion))
  add(path_575031, "subscriptionId", newJString(subscriptionId))
  add(path_575031, "ipPool", newJString(ipPool))
  add(path_575031, "location", newJString(location))
  result = call_575030.call(path_575031, query_575032, nil, nil, body_575033)

var ipPoolsCreateOrUpdate* = Call_IpPoolsCreateOrUpdate_575020(
    name: "ipPoolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/ipPools/{ipPool}",
    validator: validate_IpPoolsCreateOrUpdate_575021, base: "",
    url: url_IpPoolsCreateOrUpdate_575022, schemes: {Scheme.Https})
type
  Call_IpPoolsGet_574999 = ref object of OpenApiRestCall_574457
proc url_IpPoolsGet_575001(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "ipPool" in path, "`ipPool` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/ipPools/"),
               (kind: VariableSegment, value: "ipPool")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IpPoolsGet_575000(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Return the requested IP pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ipPool: JString (required)
  ##         : IP pool name.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575011 = path.getOrDefault("resourceGroupName")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "resourceGroupName", valid_575011
  var valid_575012 = path.getOrDefault("subscriptionId")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "subscriptionId", valid_575012
  var valid_575013 = path.getOrDefault("ipPool")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "ipPool", valid_575013
  var valid_575014 = path.getOrDefault("location")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "location", valid_575014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575015 = query.getOrDefault("api-version")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575015 != nil:
    section.add "api-version", valid_575015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575016: Call_IpPoolsGet_574999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the requested IP pool.
  ## 
  let valid = call_575016.validator(path, query, header, formData, body)
  let scheme = call_575016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575016.url(scheme.get, call_575016.host, call_575016.base,
                         call_575016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575016, url, valid)

proc call*(call_575017: Call_IpPoolsGet_574999; resourceGroupName: string;
          subscriptionId: string; ipPool: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## ipPoolsGet
  ## Return the requested IP pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ipPool: string (required)
  ##         : IP pool name.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575018 = newJObject()
  var query_575019 = newJObject()
  add(path_575018, "resourceGroupName", newJString(resourceGroupName))
  add(query_575019, "api-version", newJString(apiVersion))
  add(path_575018, "subscriptionId", newJString(subscriptionId))
  add(path_575018, "ipPool", newJString(ipPool))
  add(path_575018, "location", newJString(location))
  result = call_575017.call(path_575018, query_575019, nil, nil, nil)

var ipPoolsGet* = Call_IpPoolsGet_574999(name: "ipPoolsGet",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/ipPools/{ipPool}",
                                      validator: validate_IpPoolsGet_575000,
                                      base: "", url: url_IpPoolsGet_575001,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
