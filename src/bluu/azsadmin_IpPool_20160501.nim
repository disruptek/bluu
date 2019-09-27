
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "azsadmin-IpPool"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IpPoolsList_593646 = ref object of OpenApiRestCall_593424
proc url_IpPoolsList_593648(protocol: Scheme; host: string; base: string;
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

proc validate_IpPoolsList_593647(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593809 = path.getOrDefault("resourceGroupName")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "resourceGroupName", valid_593809
  var valid_593810 = path.getOrDefault("subscriptionId")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "subscriptionId", valid_593810
  var valid_593811 = path.getOrDefault("location")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "location", valid_593811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593825 = query.getOrDefault("api-version")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593825 != nil:
    section.add "api-version", valid_593825
  var valid_593826 = query.getOrDefault("$filter")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "$filter", valid_593826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593853: Call_IpPoolsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all IP pools at a certain location.
  ## 
  let valid = call_593853.validator(path, query, header, formData, body)
  let scheme = call_593853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593853.url(scheme.get, call_593853.host, call_593853.base,
                         call_593853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593853, url, valid)

proc call*(call_593924: Call_IpPoolsList_593646; resourceGroupName: string;
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
  var path_593925 = newJObject()
  var query_593927 = newJObject()
  add(path_593925, "resourceGroupName", newJString(resourceGroupName))
  add(query_593927, "api-version", newJString(apiVersion))
  add(path_593925, "subscriptionId", newJString(subscriptionId))
  add(path_593925, "location", newJString(location))
  add(query_593927, "$filter", newJString(Filter))
  result = call_593924.call(path_593925, query_593927, nil, nil, nil)

var ipPoolsList* = Call_IpPoolsList_593646(name: "ipPoolsList",
                                        meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/ipPools",
                                        validator: validate_IpPoolsList_593647,
                                        base: "", url: url_IpPoolsList_593648,
                                        schemes: {Scheme.Https})
type
  Call_IpPoolsCreateOrUpdate_593987 = ref object of OpenApiRestCall_593424
proc url_IpPoolsCreateOrUpdate_593989(protocol: Scheme; host: string; base: string;
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

proc validate_IpPoolsCreateOrUpdate_593988(path: JsonNode; query: JsonNode;
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
  var valid_593990 = path.getOrDefault("resourceGroupName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "resourceGroupName", valid_593990
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  var valid_593992 = path.getOrDefault("ipPool")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "ipPool", valid_593992
  var valid_593993 = path.getOrDefault("location")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "location", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593994 != nil:
    section.add "api-version", valid_593994
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

proc call*(call_593996: Call_IpPoolsCreateOrUpdate_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an IP pool.  Once created an IP pool cannot be deleted.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_IpPoolsCreateOrUpdate_593987; pool: JsonNode;
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
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  var body_594000 = newJObject()
  if pool != nil:
    body_594000 = pool
  add(path_593998, "resourceGroupName", newJString(resourceGroupName))
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  add(path_593998, "ipPool", newJString(ipPool))
  add(path_593998, "location", newJString(location))
  result = call_593997.call(path_593998, query_593999, nil, nil, body_594000)

var ipPoolsCreateOrUpdate* = Call_IpPoolsCreateOrUpdate_593987(
    name: "ipPoolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/ipPools/{ipPool}",
    validator: validate_IpPoolsCreateOrUpdate_593988, base: "",
    url: url_IpPoolsCreateOrUpdate_593989, schemes: {Scheme.Https})
type
  Call_IpPoolsGet_593966 = ref object of OpenApiRestCall_593424
proc url_IpPoolsGet_593968(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_IpPoolsGet_593967(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593978 = path.getOrDefault("resourceGroupName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "resourceGroupName", valid_593978
  var valid_593979 = path.getOrDefault("subscriptionId")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "subscriptionId", valid_593979
  var valid_593980 = path.getOrDefault("ipPool")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "ipPool", valid_593980
  var valid_593981 = path.getOrDefault("location")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "location", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_IpPoolsGet_593966; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the requested IP pool.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_IpPoolsGet_593966; resourceGroupName: string;
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
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(path_593985, "resourceGroupName", newJString(resourceGroupName))
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "subscriptionId", newJString(subscriptionId))
  add(path_593985, "ipPool", newJString(ipPool))
  add(path_593985, "location", newJString(location))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var ipPoolsGet* = Call_IpPoolsGet_593966(name: "ipPoolsGet",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/ipPools/{ipPool}",
                                      validator: validate_IpPoolsGet_593967,
                                      base: "", url: url_IpPoolsGet_593968,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
