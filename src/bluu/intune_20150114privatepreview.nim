
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: IntuneResourceManagementClient
## version: 2015-01-14-privatepreview
## termsOfService: (not provided)
## license: (not provided)
## 
## Microsoft.Intune Resource provider Api features in the swagger-2.0 specification
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "intune"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetLocations_593630 = ref object of OpenApiRestCall_593408
proc url_GetLocations_593632(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetLocations_593631(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns location for user tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_GetLocations_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns location for user tenant.
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_GetLocations_593630; apiVersion: string): Recallable =
  ## getLocations
  ## Returns location for user tenant.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var getLocations* = Call_GetLocations_593630(name: "getLocations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations",
    validator: validate_GetLocations_593631, base: "", url: url_GetLocations_593632,
    schemes: {Scheme.Https})
type
  Call_GetLocationByHostName_593926 = ref object of OpenApiRestCall_593408
proc url_GetLocationByHostName_593928(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetLocationByHostName_593927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns location for given tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593929 = query.getOrDefault("api-version")
  valid_593929 = validateParameter(valid_593929, JString, required = true,
                                 default = nil)
  if valid_593929 != nil:
    section.add "api-version", valid_593929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593930: Call_GetLocationByHostName_593926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns location for given tenant.
  ## 
  let valid = call_593930.validator(path, query, header, formData, body)
  let scheme = call_593930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593930.url(scheme.get, call_593930.host, call_593930.base,
                         call_593930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593930, url, valid)

proc call*(call_593931: Call_GetLocationByHostName_593926; apiVersion: string): Recallable =
  ## getLocationByHostName
  ## Returns location for given tenant.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  var query_593932 = newJObject()
  add(query_593932, "api-version", newJString(apiVersion))
  result = call_593931.call(nil, query_593932, nil, nil, nil)

var getLocationByHostName* = Call_GetLocationByHostName_593926(
    name: "getLocationByHostName", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/hostName",
    validator: validate_GetLocationByHostName_593927, base: "",
    url: url_GetLocationByHostName_593928, schemes: {Scheme.Https})
type
  Call_AndroidGetAppForMAMPolicy_593933 = ref object of OpenApiRestCall_593408
proc url_AndroidGetAppForMAMPolicy_593935(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/AndroidPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/apps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidGetAppForMAMPolicy_593934(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get apps for an AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_593951 = path.getOrDefault("hostName")
  valid_593951 = validateParameter(valid_593951, JString, required = true,
                                 default = nil)
  if valid_593951 != nil:
    section.add "hostName", valid_593951
  var valid_593952 = path.getOrDefault("policyName")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "policyName", valid_593952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593953 = query.getOrDefault("api-version")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "api-version", valid_593953
  var valid_593954 = query.getOrDefault("$top")
  valid_593954 = validateParameter(valid_593954, JInt, required = false, default = nil)
  if valid_593954 != nil:
    section.add "$top", valid_593954
  var valid_593955 = query.getOrDefault("$select")
  valid_593955 = validateParameter(valid_593955, JString, required = false,
                                 default = nil)
  if valid_593955 != nil:
    section.add "$select", valid_593955
  var valid_593956 = query.getOrDefault("$filter")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = nil)
  if valid_593956 != nil:
    section.add "$filter", valid_593956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593957: Call_AndroidGetAppForMAMPolicy_593933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get apps for an AndroidMAMPolicy.
  ## 
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_AndroidGetAppForMAMPolicy_593933; apiVersion: string;
          hostName: string; policyName: string; Top: int = 0; Select: string = "";
          Filter: string = ""): Recallable =
  ## androidGetAppForMAMPolicy
  ## Get apps for an AndroidMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593959 = newJObject()
  var query_593960 = newJObject()
  add(query_593960, "api-version", newJString(apiVersion))
  add(query_593960, "$top", newJInt(Top))
  add(query_593960, "$select", newJString(Select))
  add(path_593959, "hostName", newJString(hostName))
  add(path_593959, "policyName", newJString(policyName))
  add(query_593960, "$filter", newJString(Filter))
  result = call_593958.call(path_593959, query_593960, nil, nil, nil)

var androidGetAppForMAMPolicy* = Call_AndroidGetAppForMAMPolicy_593933(
    name: "androidGetAppForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/AndroidPolicies/{policyName}/apps",
    validator: validate_AndroidGetAppForMAMPolicy_593934, base: "",
    url: url_AndroidGetAppForMAMPolicy_593935, schemes: {Scheme.Https})
type
  Call_AndroidGetMAMPolicies_593961 = ref object of OpenApiRestCall_593408
proc url_AndroidGetMAMPolicies_593963(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidGetMAMPolicies_593962(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Intune Android policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_593964 = path.getOrDefault("hostName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "hostName", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  var valid_593966 = query.getOrDefault("$top")
  valid_593966 = validateParameter(valid_593966, JInt, required = false, default = nil)
  if valid_593966 != nil:
    section.add "$top", valid_593966
  var valid_593967 = query.getOrDefault("$select")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "$select", valid_593967
  var valid_593968 = query.getOrDefault("$filter")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "$filter", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_AndroidGetMAMPolicies_593961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Android policies.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_AndroidGetMAMPolicies_593961; apiVersion: string;
          hostName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## androidGetMAMPolicies
  ## Returns Intune Android policies.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(query_593972, "api-version", newJString(apiVersion))
  add(query_593972, "$top", newJInt(Top))
  add(query_593972, "$select", newJString(Select))
  add(path_593971, "hostName", newJString(hostName))
  add(query_593972, "$filter", newJString(Filter))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var androidGetMAMPolicies* = Call_AndroidGetMAMPolicies_593961(
    name: "androidGetMAMPolicies", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies",
    validator: validate_AndroidGetMAMPolicies_593962, base: "",
    url: url_AndroidGetMAMPolicies_593963, schemes: {Scheme.Https})
type
  Call_AndroidCreateOrUpdateMAMPolicy_593984 = ref object of OpenApiRestCall_593408
proc url_AndroidCreateOrUpdateMAMPolicy_593986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidCreateOrUpdateMAMPolicy_593985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594004 = path.getOrDefault("hostName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "hostName", valid_594004
  var valid_594005 = path.getOrDefault("policyName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "policyName", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_AndroidCreateOrUpdateMAMPolicy_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates AndroidMAMPolicy.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_AndroidCreateOrUpdateMAMPolicy_593984;
          apiVersion: string; hostName: string; policyName: string;
          parameters: JsonNode): Recallable =
  ## androidCreateOrUpdateMAMPolicy
  ## Creates or updates AndroidMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  var body_594012 = newJObject()
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "hostName", newJString(hostName))
  add(path_594010, "policyName", newJString(policyName))
  if parameters != nil:
    body_594012 = parameters
  result = call_594009.call(path_594010, query_594011, nil, nil, body_594012)

var androidCreateOrUpdateMAMPolicy* = Call_AndroidCreateOrUpdateMAMPolicy_593984(
    name: "androidCreateOrUpdateMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidCreateOrUpdateMAMPolicy_593985, base: "",
    url: url_AndroidCreateOrUpdateMAMPolicy_593986, schemes: {Scheme.Https})
type
  Call_AndroidGetMAMPolicyByName_593973 = ref object of OpenApiRestCall_593408
proc url_AndroidGetMAMPolicyByName_593975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidGetMAMPolicyByName_593974(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns AndroidMAMPolicy with given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_593976 = path.getOrDefault("hostName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "hostName", valid_593976
  var valid_593977 = path.getOrDefault("policyName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "policyName", valid_593977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  var valid_593979 = query.getOrDefault("$select")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "$select", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_AndroidGetMAMPolicyByName_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns AndroidMAMPolicy with given name.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_AndroidGetMAMPolicyByName_593973; apiVersion: string;
          hostName: string; policyName: string; Select: string = ""): Recallable =
  ## androidGetMAMPolicyByName
  ## Returns AndroidMAMPolicy with given name.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "api-version", newJString(apiVersion))
  add(query_593983, "$select", newJString(Select))
  add(path_593982, "hostName", newJString(hostName))
  add(path_593982, "policyName", newJString(policyName))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var androidGetMAMPolicyByName* = Call_AndroidGetMAMPolicyByName_593973(
    name: "androidGetMAMPolicyByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidGetMAMPolicyByName_593974, base: "",
    url: url_AndroidGetMAMPolicyByName_593975, schemes: {Scheme.Https})
type
  Call_AndroidPatchMAMPolicy_594023 = ref object of OpenApiRestCall_593408
proc url_AndroidPatchMAMPolicy_594025(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidPatchMAMPolicy_594024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594026 = path.getOrDefault("hostName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "hostName", valid_594026
  var valid_594027 = path.getOrDefault("policyName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "policyName", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_AndroidPatchMAMPolicy_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch AndroidMAMPolicy.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_AndroidPatchMAMPolicy_594023; apiVersion: string;
          hostName: string; policyName: string; parameters: JsonNode): Recallable =
  ## androidPatchMAMPolicy
  ## Patch AndroidMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  var body_594034 = newJObject()
  add(query_594033, "api-version", newJString(apiVersion))
  add(path_594032, "hostName", newJString(hostName))
  add(path_594032, "policyName", newJString(policyName))
  if parameters != nil:
    body_594034 = parameters
  result = call_594031.call(path_594032, query_594033, nil, nil, body_594034)

var androidPatchMAMPolicy* = Call_AndroidPatchMAMPolicy_594023(
    name: "androidPatchMAMPolicy", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidPatchMAMPolicy_594024, base: "",
    url: url_AndroidPatchMAMPolicy_594025, schemes: {Scheme.Https})
type
  Call_AndroidDeleteMAMPolicy_594013 = ref object of OpenApiRestCall_593408
proc url_AndroidDeleteMAMPolicy_594015(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidDeleteMAMPolicy_594014(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Android Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594016 = path.getOrDefault("hostName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "hostName", valid_594016
  var valid_594017 = path.getOrDefault("policyName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "policyName", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_AndroidDeleteMAMPolicy_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Android Policy
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_AndroidDeleteMAMPolicy_594013; apiVersion: string;
          hostName: string; policyName: string): Recallable =
  ## androidDeleteMAMPolicy
  ## Delete Android Policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(query_594022, "api-version", newJString(apiVersion))
  add(path_594021, "hostName", newJString(hostName))
  add(path_594021, "policyName", newJString(policyName))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var androidDeleteMAMPolicy* = Call_AndroidDeleteMAMPolicy_594013(
    name: "androidDeleteMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidDeleteMAMPolicy_594014, base: "",
    url: url_AndroidDeleteMAMPolicy_594015, schemes: {Scheme.Https})
type
  Call_AndroidAddAppForMAMPolicy_594035 = ref object of OpenApiRestCall_593408
proc url_AndroidAddAppForMAMPolicy_594037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidAddAppForMAMPolicy_594036(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add app to an AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appName: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appName` field"
  var valid_594038 = path.getOrDefault("appName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "appName", valid_594038
  var valid_594039 = path.getOrDefault("hostName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "hostName", valid_594039
  var valid_594040 = path.getOrDefault("policyName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "policyName", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_AndroidAddAppForMAMPolicy_594035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add app to an AndroidMAMPolicy.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_AndroidAddAppForMAMPolicy_594035; apiVersion: string;
          appName: string; hostName: string; policyName: string; parameters: JsonNode): Recallable =
  ## androidAddAppForMAMPolicy
  ## Add app to an AndroidMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   appName: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  var body_594047 = newJObject()
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "appName", newJString(appName))
  add(path_594045, "hostName", newJString(hostName))
  add(path_594045, "policyName", newJString(policyName))
  if parameters != nil:
    body_594047 = parameters
  result = call_594044.call(path_594045, query_594046, nil, nil, body_594047)

var androidAddAppForMAMPolicy* = Call_AndroidAddAppForMAMPolicy_594035(
    name: "androidAddAppForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/apps/{appName}",
    validator: validate_AndroidAddAppForMAMPolicy_594036, base: "",
    url: url_AndroidAddAppForMAMPolicy_594037, schemes: {Scheme.Https})
type
  Call_AndroidDeleteAppForMAMPolicy_594048 = ref object of OpenApiRestCall_593408
proc url_AndroidDeleteAppForMAMPolicy_594050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidDeleteAppForMAMPolicy_594049(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete App for Android Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appName: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appName` field"
  var valid_594051 = path.getOrDefault("appName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "appName", valid_594051
  var valid_594052 = path.getOrDefault("hostName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "hostName", valid_594052
  var valid_594053 = path.getOrDefault("policyName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "policyName", valid_594053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594054 = query.getOrDefault("api-version")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "api-version", valid_594054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_AndroidDeleteAppForMAMPolicy_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete App for Android Policy
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_AndroidDeleteAppForMAMPolicy_594048;
          apiVersion: string; appName: string; hostName: string; policyName: string): Recallable =
  ## androidDeleteAppForMAMPolicy
  ## Delete App for Android Policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   appName: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "appName", newJString(appName))
  add(path_594057, "hostName", newJString(hostName))
  add(path_594057, "policyName", newJString(policyName))
  result = call_594056.call(path_594057, query_594058, nil, nil, nil)

var androidDeleteAppForMAMPolicy* = Call_AndroidDeleteAppForMAMPolicy_594048(
    name: "androidDeleteAppForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/apps/{appName}",
    validator: validate_AndroidDeleteAppForMAMPolicy_594049, base: "",
    url: url_AndroidDeleteAppForMAMPolicy_594050, schemes: {Scheme.Https})
type
  Call_AndroidGetGroupsForMAMPolicy_594059 = ref object of OpenApiRestCall_593408
proc url_AndroidGetGroupsForMAMPolicy_594061(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidGetGroupsForMAMPolicy_594060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns groups for a given AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : policy name for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594062 = path.getOrDefault("hostName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "hostName", valid_594062
  var valid_594063 = path.getOrDefault("policyName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "policyName", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_AndroidGetGroupsForMAMPolicy_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns groups for a given AndroidMAMPolicy.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_AndroidGetGroupsForMAMPolicy_594059;
          apiVersion: string; hostName: string; policyName: string): Recallable =
  ## androidGetGroupsForMAMPolicy
  ## Returns groups for a given AndroidMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : policy name for the tenant
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(query_594068, "api-version", newJString(apiVersion))
  add(path_594067, "hostName", newJString(hostName))
  add(path_594067, "policyName", newJString(policyName))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var androidGetGroupsForMAMPolicy* = Call_AndroidGetGroupsForMAMPolicy_594059(
    name: "androidGetGroupsForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups",
    validator: validate_AndroidGetGroupsForMAMPolicy_594060, base: "",
    url: url_AndroidGetGroupsForMAMPolicy_594061, schemes: {Scheme.Https})
type
  Call_AndroidAddGroupForMAMPolicy_594069 = ref object of OpenApiRestCall_593408
proc url_AndroidAddGroupForMAMPolicy_594071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidAddGroupForMAMPolicy_594070(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add group to an AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : group Id
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594072 = path.getOrDefault("groupId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "groupId", valid_594072
  var valid_594073 = path.getOrDefault("hostName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "hostName", valid_594073
  var valid_594074 = path.getOrDefault("policyName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "policyName", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594075 = query.getOrDefault("api-version")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "api-version", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_AndroidAddGroupForMAMPolicy_594069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add group to an AndroidMAMPolicy.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_AndroidAddGroupForMAMPolicy_594069; groupId: string;
          apiVersion: string; hostName: string; policyName: string;
          parameters: JsonNode): Recallable =
  ## androidAddGroupForMAMPolicy
  ## Add group to an AndroidMAMPolicy.
  ##   groupId: string (required)
  ##          : group Id
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  var body_594081 = newJObject()
  add(path_594079, "groupId", newJString(groupId))
  add(query_594080, "api-version", newJString(apiVersion))
  add(path_594079, "hostName", newJString(hostName))
  add(path_594079, "policyName", newJString(policyName))
  if parameters != nil:
    body_594081 = parameters
  result = call_594078.call(path_594079, query_594080, nil, nil, body_594081)

var androidAddGroupForMAMPolicy* = Call_AndroidAddGroupForMAMPolicy_594069(
    name: "androidAddGroupForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups/{groupId}",
    validator: validate_AndroidAddGroupForMAMPolicy_594070, base: "",
    url: url_AndroidAddGroupForMAMPolicy_594071, schemes: {Scheme.Https})
type
  Call_AndroidDeleteGroupForMAMPolicy_594082 = ref object of OpenApiRestCall_593408
proc url_AndroidDeleteGroupForMAMPolicy_594084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/androidPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidDeleteGroupForMAMPolicy_594083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Group for Android Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594085 = path.getOrDefault("groupId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "groupId", valid_594085
  var valid_594086 = path.getOrDefault("hostName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "hostName", valid_594086
  var valid_594087 = path.getOrDefault("policyName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "policyName", valid_594087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_AndroidDeleteGroupForMAMPolicy_594082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group for Android Policy
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_AndroidDeleteGroupForMAMPolicy_594082;
          groupId: string; apiVersion: string; hostName: string; policyName: string): Recallable =
  ## androidDeleteGroupForMAMPolicy
  ## Delete Group for Android Policy
  ##   groupId: string (required)
  ##          : application unique Name
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(path_594091, "groupId", newJString(groupId))
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "hostName", newJString(hostName))
  add(path_594091, "policyName", newJString(policyName))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var androidDeleteGroupForMAMPolicy* = Call_AndroidDeleteGroupForMAMPolicy_594082(
    name: "androidDeleteGroupForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups/{groupId}",
    validator: validate_AndroidDeleteGroupForMAMPolicy_594083, base: "",
    url: url_AndroidDeleteGroupForMAMPolicy_594084, schemes: {Scheme.Https})
type
  Call_GetApps_594093 = ref object of OpenApiRestCall_593408
proc url_GetApps_594095(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/apps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetApps_594094(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Intune Manageable apps.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594096 = path.getOrDefault("hostName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "hostName", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  var valid_594098 = query.getOrDefault("$top")
  valid_594098 = validateParameter(valid_594098, JInt, required = false, default = nil)
  if valid_594098 != nil:
    section.add "$top", valid_594098
  var valid_594099 = query.getOrDefault("$select")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "$select", valid_594099
  var valid_594100 = query.getOrDefault("$filter")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "$filter", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_GetApps_594093; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Manageable apps.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_GetApps_594093; apiVersion: string; hostName: string;
          Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## getApps
  ## Returns Intune Manageable apps.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(query_594104, "api-version", newJString(apiVersion))
  add(query_594104, "$top", newJInt(Top))
  add(query_594104, "$select", newJString(Select))
  add(path_594103, "hostName", newJString(hostName))
  add(query_594104, "$filter", newJString(Filter))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var getApps* = Call_GetApps_594093(name: "getApps", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/apps",
                                validator: validate_GetApps_594094, base: "",
                                url: url_GetApps_594095, schemes: {Scheme.Https})
type
  Call_GetMAMFlaggedUsers_594105 = ref object of OpenApiRestCall_593408
proc url_GetMAMFlaggedUsers_594107(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/flaggedUsers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetMAMFlaggedUsers_594106(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns Intune flagged user collection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594108 = path.getOrDefault("hostName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "hostName", valid_594108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "api-version", valid_594109
  var valid_594110 = query.getOrDefault("$top")
  valid_594110 = validateParameter(valid_594110, JInt, required = false, default = nil)
  if valid_594110 != nil:
    section.add "$top", valid_594110
  var valid_594111 = query.getOrDefault("$select")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "$select", valid_594111
  var valid_594112 = query.getOrDefault("$filter")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "$filter", valid_594112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594113: Call_GetMAMFlaggedUsers_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged user collection
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_GetMAMFlaggedUsers_594105; apiVersion: string;
          hostName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## getMAMFlaggedUsers
  ## Returns Intune flagged user collection
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  add(query_594116, "api-version", newJString(apiVersion))
  add(query_594116, "$top", newJInt(Top))
  add(query_594116, "$select", newJString(Select))
  add(path_594115, "hostName", newJString(hostName))
  add(query_594116, "$filter", newJString(Filter))
  result = call_594114.call(path_594115, query_594116, nil, nil, nil)

var getMAMFlaggedUsers* = Call_GetMAMFlaggedUsers_594105(
    name: "getMAMFlaggedUsers", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers",
    validator: validate_GetMAMFlaggedUsers_594106, base: "",
    url: url_GetMAMFlaggedUsers_594107, schemes: {Scheme.Https})
type
  Call_GetMAMFlaggedUserByName_594117 = ref object of OpenApiRestCall_593408
proc url_GetMAMFlaggedUserByName_594119(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/flaggedUsers/"),
               (kind: VariableSegment, value: "userName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetMAMFlaggedUserByName_594118(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Intune flagged user details
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   userName: JString (required)
  ##           : Flagged userName
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594120 = path.getOrDefault("hostName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "hostName", valid_594120
  var valid_594121 = path.getOrDefault("userName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "userName", valid_594121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594122 = query.getOrDefault("api-version")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "api-version", valid_594122
  var valid_594123 = query.getOrDefault("$select")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "$select", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_GetMAMFlaggedUserByName_594117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged user details
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_GetMAMFlaggedUserByName_594117; apiVersion: string;
          hostName: string; userName: string; Select: string = ""): Recallable =
  ## getMAMFlaggedUserByName
  ## Returns Intune flagged user details
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : Flagged userName
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  add(query_594127, "api-version", newJString(apiVersion))
  add(query_594127, "$select", newJString(Select))
  add(path_594126, "hostName", newJString(hostName))
  add(path_594126, "userName", newJString(userName))
  result = call_594125.call(path_594126, query_594127, nil, nil, nil)

var getMAMFlaggedUserByName* = Call_GetMAMFlaggedUserByName_594117(
    name: "getMAMFlaggedUserByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers/{userName}",
    validator: validate_GetMAMFlaggedUserByName_594118, base: "",
    url: url_GetMAMFlaggedUserByName_594119, schemes: {Scheme.Https})
type
  Call_GetMAMUserFlaggedEnrolledApps_594128 = ref object of OpenApiRestCall_593408
proc url_GetMAMUserFlaggedEnrolledApps_594130(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/flaggedUsers/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/flaggedEnrolledApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetMAMUserFlaggedEnrolledApps_594129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Intune flagged enrolled app collection for the User
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   userName: JString (required)
  ##           : User name for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594131 = path.getOrDefault("hostName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "hostName", valid_594131
  var valid_594132 = path.getOrDefault("userName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "userName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  var valid_594134 = query.getOrDefault("$top")
  valid_594134 = validateParameter(valid_594134, JInt, required = false, default = nil)
  if valid_594134 != nil:
    section.add "$top", valid_594134
  var valid_594135 = query.getOrDefault("$select")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "$select", valid_594135
  var valid_594136 = query.getOrDefault("$filter")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "$filter", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_GetMAMUserFlaggedEnrolledApps_594128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged enrolled app collection for the User
  ## 
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_GetMAMUserFlaggedEnrolledApps_594128;
          apiVersion: string; hostName: string; userName: string; Top: int = 0;
          Select: string = ""; Filter: string = ""): Recallable =
  ## getMAMUserFlaggedEnrolledApps
  ## Returns Intune flagged enrolled app collection for the User
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : User name for the tenant
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594139 = newJObject()
  var query_594140 = newJObject()
  add(query_594140, "api-version", newJString(apiVersion))
  add(query_594140, "$top", newJInt(Top))
  add(query_594140, "$select", newJString(Select))
  add(path_594139, "hostName", newJString(hostName))
  add(path_594139, "userName", newJString(userName))
  add(query_594140, "$filter", newJString(Filter))
  result = call_594138.call(path_594139, query_594140, nil, nil, nil)

var getMAMUserFlaggedEnrolledApps* = Call_GetMAMUserFlaggedEnrolledApps_594128(
    name: "getMAMUserFlaggedEnrolledApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers/{userName}/flaggedEnrolledApps",
    validator: validate_GetMAMUserFlaggedEnrolledApps_594129, base: "",
    url: url_GetMAMUserFlaggedEnrolledApps_594130, schemes: {Scheme.Https})
type
  Call_IosGetMAMPolicies_594141 = ref object of OpenApiRestCall_593408
proc url_IosGetMAMPolicies_594143(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosGetMAMPolicies_594142(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns Intune iOSPolicies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594144 = path.getOrDefault("hostName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "hostName", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "api-version", valid_594145
  var valid_594146 = query.getOrDefault("$top")
  valid_594146 = validateParameter(valid_594146, JInt, required = false, default = nil)
  if valid_594146 != nil:
    section.add "$top", valid_594146
  var valid_594147 = query.getOrDefault("$select")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "$select", valid_594147
  var valid_594148 = query.getOrDefault("$filter")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "$filter", valid_594148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594149: Call_IosGetMAMPolicies_594141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune iOSPolicies.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_IosGetMAMPolicies_594141; apiVersion: string;
          hostName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## iosGetMAMPolicies
  ## Returns Intune iOSPolicies.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  add(query_594152, "api-version", newJString(apiVersion))
  add(query_594152, "$top", newJInt(Top))
  add(query_594152, "$select", newJString(Select))
  add(path_594151, "hostName", newJString(hostName))
  add(query_594152, "$filter", newJString(Filter))
  result = call_594150.call(path_594151, query_594152, nil, nil, nil)

var iosGetMAMPolicies* = Call_IosGetMAMPolicies_594141(name: "iosGetMAMPolicies",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies",
    validator: validate_IosGetMAMPolicies_594142, base: "",
    url: url_IosGetMAMPolicies_594143, schemes: {Scheme.Https})
type
  Call_IosCreateOrUpdateMAMPolicy_594164 = ref object of OpenApiRestCall_593408
proc url_IosCreateOrUpdateMAMPolicy_594166(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosCreateOrUpdateMAMPolicy_594165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594167 = path.getOrDefault("hostName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "hostName", valid_594167
  var valid_594168 = path.getOrDefault("policyName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "policyName", valid_594168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594169 = query.getOrDefault("api-version")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "api-version", valid_594169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_IosCreateOrUpdateMAMPolicy_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates iOSMAMPolicy.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_IosCreateOrUpdateMAMPolicy_594164; apiVersion: string;
          hostName: string; policyName: string; parameters: JsonNode): Recallable =
  ## iosCreateOrUpdateMAMPolicy
  ## Creates or updates iOSMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  var body_594175 = newJObject()
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "hostName", newJString(hostName))
  add(path_594173, "policyName", newJString(policyName))
  if parameters != nil:
    body_594175 = parameters
  result = call_594172.call(path_594173, query_594174, nil, nil, body_594175)

var iosCreateOrUpdateMAMPolicy* = Call_IosCreateOrUpdateMAMPolicy_594164(
    name: "iosCreateOrUpdateMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosCreateOrUpdateMAMPolicy_594165, base: "",
    url: url_IosCreateOrUpdateMAMPolicy_594166, schemes: {Scheme.Https})
type
  Call_IosGetMAMPolicyByName_594153 = ref object of OpenApiRestCall_593408
proc url_IosGetMAMPolicyByName_594155(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosGetMAMPolicyByName_594154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Intune iOS policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594156 = path.getOrDefault("hostName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "hostName", valid_594156
  var valid_594157 = path.getOrDefault("policyName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "policyName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  var valid_594159 = query.getOrDefault("$select")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "$select", valid_594159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_IosGetMAMPolicyByName_594153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune iOS policies.
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_IosGetMAMPolicyByName_594153; apiVersion: string;
          hostName: string; policyName: string; Select: string = ""): Recallable =
  ## iosGetMAMPolicyByName
  ## Returns Intune iOS policies.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  add(query_594163, "api-version", newJString(apiVersion))
  add(query_594163, "$select", newJString(Select))
  add(path_594162, "hostName", newJString(hostName))
  add(path_594162, "policyName", newJString(policyName))
  result = call_594161.call(path_594162, query_594163, nil, nil, nil)

var iosGetMAMPolicyByName* = Call_IosGetMAMPolicyByName_594153(
    name: "iosGetMAMPolicyByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosGetMAMPolicyByName_594154, base: "",
    url: url_IosGetMAMPolicyByName_594155, schemes: {Scheme.Https})
type
  Call_IosPatchMAMPolicy_594186 = ref object of OpenApiRestCall_593408
proc url_IosPatchMAMPolicy_594188(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosPatchMAMPolicy_594187(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ##  patch an iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594189 = path.getOrDefault("hostName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "hostName", valid_594189
  var valid_594190 = path.getOrDefault("policyName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "policyName", valid_594190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594191 = query.getOrDefault("api-version")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "api-version", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_IosPatchMAMPolicy_594186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  patch an iOSMAMPolicy.
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_IosPatchMAMPolicy_594186; apiVersion: string;
          hostName: string; policyName: string; parameters: JsonNode): Recallable =
  ## iosPatchMAMPolicy
  ##  patch an iOSMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  var body_594197 = newJObject()
  add(query_594196, "api-version", newJString(apiVersion))
  add(path_594195, "hostName", newJString(hostName))
  add(path_594195, "policyName", newJString(policyName))
  if parameters != nil:
    body_594197 = parameters
  result = call_594194.call(path_594195, query_594196, nil, nil, body_594197)

var iosPatchMAMPolicy* = Call_IosPatchMAMPolicy_594186(name: "iosPatchMAMPolicy",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosPatchMAMPolicy_594187, base: "",
    url: url_IosPatchMAMPolicy_594188, schemes: {Scheme.Https})
type
  Call_IosDeleteMAMPolicy_594176 = ref object of OpenApiRestCall_593408
proc url_IosDeleteMAMPolicy_594178(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosDeleteMAMPolicy_594177(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete Ios Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594179 = path.getOrDefault("hostName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "hostName", valid_594179
  var valid_594180 = path.getOrDefault("policyName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "policyName", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594181 = query.getOrDefault("api-version")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "api-version", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_IosDeleteMAMPolicy_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Ios Policy
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_IosDeleteMAMPolicy_594176; apiVersion: string;
          hostName: string; policyName: string): Recallable =
  ## iosDeleteMAMPolicy
  ## Delete Ios Policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "hostName", newJString(hostName))
  add(path_594184, "policyName", newJString(policyName))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var iosDeleteMAMPolicy* = Call_IosDeleteMAMPolicy_594176(
    name: "iosDeleteMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosDeleteMAMPolicy_594177, base: "",
    url: url_IosDeleteMAMPolicy_594178, schemes: {Scheme.Https})
type
  Call_IosGetAppForMAMPolicy_594198 = ref object of OpenApiRestCall_593408
proc url_IosGetAppForMAMPolicy_594200(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/apps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosGetAppForMAMPolicy_594199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get apps for an iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594201 = path.getOrDefault("hostName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "hostName", valid_594201
  var valid_594202 = path.getOrDefault("policyName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "policyName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  var valid_594204 = query.getOrDefault("$top")
  valid_594204 = validateParameter(valid_594204, JInt, required = false, default = nil)
  if valid_594204 != nil:
    section.add "$top", valid_594204
  var valid_594205 = query.getOrDefault("$select")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "$select", valid_594205
  var valid_594206 = query.getOrDefault("$filter")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "$filter", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594207: Call_IosGetAppForMAMPolicy_594198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get apps for an iOSMAMPolicy.
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_IosGetAppForMAMPolicy_594198; apiVersion: string;
          hostName: string; policyName: string; Top: int = 0; Select: string = "";
          Filter: string = ""): Recallable =
  ## iosGetAppForMAMPolicy
  ## Get apps for an iOSMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594209 = newJObject()
  var query_594210 = newJObject()
  add(query_594210, "api-version", newJString(apiVersion))
  add(query_594210, "$top", newJInt(Top))
  add(query_594210, "$select", newJString(Select))
  add(path_594209, "hostName", newJString(hostName))
  add(path_594209, "policyName", newJString(policyName))
  add(query_594210, "$filter", newJString(Filter))
  result = call_594208.call(path_594209, query_594210, nil, nil, nil)

var iosGetAppForMAMPolicy* = Call_IosGetAppForMAMPolicy_594198(
    name: "iosGetAppForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps",
    validator: validate_IosGetAppForMAMPolicy_594199, base: "",
    url: url_IosGetAppForMAMPolicy_594200, schemes: {Scheme.Https})
type
  Call_IosAddAppForMAMPolicy_594211 = ref object of OpenApiRestCall_593408
proc url_IosAddAppForMAMPolicy_594213(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosAddAppForMAMPolicy_594212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add app to an iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appName: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appName` field"
  var valid_594214 = path.getOrDefault("appName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "appName", valid_594214
  var valid_594215 = path.getOrDefault("hostName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "hostName", valid_594215
  var valid_594216 = path.getOrDefault("policyName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "policyName", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add an app to an ios policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_IosAddAppForMAMPolicy_594211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add app to an iOSMAMPolicy.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_IosAddAppForMAMPolicy_594211; apiVersion: string;
          appName: string; hostName: string; policyName: string; parameters: JsonNode): Recallable =
  ## iosAddAppForMAMPolicy
  ## Add app to an iOSMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   appName: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add an app to an ios policy.
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  var body_594223 = newJObject()
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "appName", newJString(appName))
  add(path_594221, "hostName", newJString(hostName))
  add(path_594221, "policyName", newJString(policyName))
  if parameters != nil:
    body_594223 = parameters
  result = call_594220.call(path_594221, query_594222, nil, nil, body_594223)

var iosAddAppForMAMPolicy* = Call_IosAddAppForMAMPolicy_594211(
    name: "iosAddAppForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps/{appName}",
    validator: validate_IosAddAppForMAMPolicy_594212, base: "",
    url: url_IosAddAppForMAMPolicy_594213, schemes: {Scheme.Https})
type
  Call_IosDeleteAppForMAMPolicy_594224 = ref object of OpenApiRestCall_593408
proc url_IosDeleteAppForMAMPolicy_594226(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosDeleteAppForMAMPolicy_594225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete App for Ios Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appName: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appName` field"
  var valid_594227 = path.getOrDefault("appName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "appName", valid_594227
  var valid_594228 = path.getOrDefault("hostName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "hostName", valid_594228
  var valid_594229 = path.getOrDefault("policyName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "policyName", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594230 = query.getOrDefault("api-version")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "api-version", valid_594230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594231: Call_IosDeleteAppForMAMPolicy_594224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete App for Ios Policy
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_IosDeleteAppForMAMPolicy_594224; apiVersion: string;
          appName: string; hostName: string; policyName: string): Recallable =
  ## iosDeleteAppForMAMPolicy
  ## Delete App for Ios Policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   appName: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "appName", newJString(appName))
  add(path_594233, "hostName", newJString(hostName))
  add(path_594233, "policyName", newJString(policyName))
  result = call_594232.call(path_594233, query_594234, nil, nil, nil)

var iosDeleteAppForMAMPolicy* = Call_IosDeleteAppForMAMPolicy_594224(
    name: "iosDeleteAppForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps/{appName}",
    validator: validate_IosDeleteAppForMAMPolicy_594225, base: "",
    url: url_IosDeleteAppForMAMPolicy_594226, schemes: {Scheme.Https})
type
  Call_IosGetGroupsForMAMPolicy_594235 = ref object of OpenApiRestCall_593408
proc url_IosGetGroupsForMAMPolicy_594237(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosGetGroupsForMAMPolicy_594236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns groups for a given iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : policy name for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594238 = path.getOrDefault("hostName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "hostName", valid_594238
  var valid_594239 = path.getOrDefault("policyName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "policyName", valid_594239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_IosGetGroupsForMAMPolicy_594235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns groups for a given iOSMAMPolicy.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_IosGetGroupsForMAMPolicy_594235; apiVersion: string;
          hostName: string; policyName: string): Recallable =
  ## iosGetGroupsForMAMPolicy
  ## Returns groups for a given iOSMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : policy name for the tenant
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "hostName", newJString(hostName))
  add(path_594243, "policyName", newJString(policyName))
  result = call_594242.call(path_594243, query_594244, nil, nil, nil)

var iosGetGroupsForMAMPolicy* = Call_IosGetGroupsForMAMPolicy_594235(
    name: "iosGetGroupsForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups",
    validator: validate_IosGetGroupsForMAMPolicy_594236, base: "",
    url: url_IosGetGroupsForMAMPolicy_594237, schemes: {Scheme.Https})
type
  Call_IosAddGroupForMAMPolicy_594245 = ref object of OpenApiRestCall_593408
proc url_IosAddGroupForMAMPolicy_594247(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosAddGroupForMAMPolicy_594246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add group to an iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : group Id
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594248 = path.getOrDefault("groupId")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "groupId", valid_594248
  var valid_594249 = path.getOrDefault("hostName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "hostName", valid_594249
  var valid_594250 = path.getOrDefault("policyName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "policyName", valid_594250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594251 = query.getOrDefault("api-version")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "api-version", valid_594251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594253: Call_IosAddGroupForMAMPolicy_594245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add group to an iOSMAMPolicy.
  ## 
  let valid = call_594253.validator(path, query, header, formData, body)
  let scheme = call_594253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594253.url(scheme.get, call_594253.host, call_594253.base,
                         call_594253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594253, url, valid)

proc call*(call_594254: Call_IosAddGroupForMAMPolicy_594245; groupId: string;
          apiVersion: string; hostName: string; policyName: string;
          parameters: JsonNode): Recallable =
  ## iosAddGroupForMAMPolicy
  ## Add group to an iOSMAMPolicy.
  ##   groupId: string (required)
  ##          : group Id
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  var path_594255 = newJObject()
  var query_594256 = newJObject()
  var body_594257 = newJObject()
  add(path_594255, "groupId", newJString(groupId))
  add(query_594256, "api-version", newJString(apiVersion))
  add(path_594255, "hostName", newJString(hostName))
  add(path_594255, "policyName", newJString(policyName))
  if parameters != nil:
    body_594257 = parameters
  result = call_594254.call(path_594255, query_594256, nil, nil, body_594257)

var iosAddGroupForMAMPolicy* = Call_IosAddGroupForMAMPolicy_594245(
    name: "iosAddGroupForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups/{groupId}",
    validator: validate_IosAddGroupForMAMPolicy_594246, base: "",
    url: url_IosAddGroupForMAMPolicy_594247, schemes: {Scheme.Https})
type
  Call_IosDeleteGroupForMAMPolicy_594258 = ref object of OpenApiRestCall_593408
proc url_IosDeleteGroupForMAMPolicy_594260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/iosPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IosDeleteGroupForMAMPolicy_594259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Group for iOS Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594261 = path.getOrDefault("groupId")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "groupId", valid_594261
  var valid_594262 = path.getOrDefault("hostName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "hostName", valid_594262
  var valid_594263 = path.getOrDefault("policyName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "policyName", valid_594263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594264 = query.getOrDefault("api-version")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "api-version", valid_594264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594265: Call_IosDeleteGroupForMAMPolicy_594258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group for iOS Policy
  ## 
  let valid = call_594265.validator(path, query, header, formData, body)
  let scheme = call_594265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594265.url(scheme.get, call_594265.host, call_594265.base,
                         call_594265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594265, url, valid)

proc call*(call_594266: Call_IosDeleteGroupForMAMPolicy_594258; groupId: string;
          apiVersion: string; hostName: string; policyName: string): Recallable =
  ## iosDeleteGroupForMAMPolicy
  ## Delete Group for iOS Policy
  ##   groupId: string (required)
  ##          : application unique Name
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_594267 = newJObject()
  var query_594268 = newJObject()
  add(path_594267, "groupId", newJString(groupId))
  add(query_594268, "api-version", newJString(apiVersion))
  add(path_594267, "hostName", newJString(hostName))
  add(path_594267, "policyName", newJString(policyName))
  result = call_594266.call(path_594267, query_594268, nil, nil, nil)

var iosDeleteGroupForMAMPolicy* = Call_IosDeleteGroupForMAMPolicy_594258(
    name: "iosDeleteGroupForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups/{groupId}",
    validator: validate_IosDeleteGroupForMAMPolicy_594259, base: "",
    url: url_IosDeleteGroupForMAMPolicy_594260, schemes: {Scheme.Https})
type
  Call_GetOperationResults_594269 = ref object of OpenApiRestCall_593408
proc url_GetOperationResults_594271(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/operationResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetOperationResults_594270(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns operationResults.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594272 = path.getOrDefault("hostName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "hostName", valid_594272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594273 = query.getOrDefault("api-version")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "api-version", valid_594273
  var valid_594274 = query.getOrDefault("$top")
  valid_594274 = validateParameter(valid_594274, JInt, required = false, default = nil)
  if valid_594274 != nil:
    section.add "$top", valid_594274
  var valid_594275 = query.getOrDefault("$select")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "$select", valid_594275
  var valid_594276 = query.getOrDefault("$filter")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "$filter", valid_594276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594277: Call_GetOperationResults_594269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns operationResults.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_GetOperationResults_594269; apiVersion: string;
          hostName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## getOperationResults
  ## Returns operationResults.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  add(query_594280, "api-version", newJString(apiVersion))
  add(query_594280, "$top", newJInt(Top))
  add(query_594280, "$select", newJString(Select))
  add(path_594279, "hostName", newJString(hostName))
  add(query_594280, "$filter", newJString(Filter))
  result = call_594278.call(path_594279, query_594280, nil, nil, nil)

var getOperationResults* = Call_GetOperationResults_594269(
    name: "getOperationResults", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/operationResults",
    validator: validate_GetOperationResults_594270, base: "",
    url: url_GetOperationResults_594271, schemes: {Scheme.Https})
type
  Call_GetMAMStatuses_594281 = ref object of OpenApiRestCall_593408
proc url_GetMAMStatuses_594283(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/statuses/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetMAMStatuses_594282(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns Intune Tenant level statuses.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594284 = path.getOrDefault("hostName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "hostName", valid_594284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594285 = query.getOrDefault("api-version")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "api-version", valid_594285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594286: Call_GetMAMStatuses_594281; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Tenant level statuses.
  ## 
  let valid = call_594286.validator(path, query, header, formData, body)
  let scheme = call_594286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594286.url(scheme.get, call_594286.host, call_594286.base,
                         call_594286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594286, url, valid)

proc call*(call_594287: Call_GetMAMStatuses_594281; apiVersion: string;
          hostName: string): Recallable =
  ## getMAMStatuses
  ## Returns Intune Tenant level statuses.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_594288 = newJObject()
  var query_594289 = newJObject()
  add(query_594289, "api-version", newJString(apiVersion))
  add(path_594288, "hostName", newJString(hostName))
  result = call_594287.call(path_594288, query_594289, nil, nil, nil)

var getMAMStatuses* = Call_GetMAMStatuses_594281(name: "getMAMStatuses",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/statuses/default",
    validator: validate_GetMAMStatuses_594282, base: "", url: url_GetMAMStatuses_594283,
    schemes: {Scheme.Https})
type
  Call_GetMAMUserDevices_594290 = ref object of OpenApiRestCall_593408
proc url_GetMAMUserDevices_594292(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetMAMUserDevices_594291(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get devices for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   userName: JString (required)
  ##           : user unique Name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594293 = path.getOrDefault("hostName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "hostName", valid_594293
  var valid_594294 = path.getOrDefault("userName")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "userName", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $top: JInt
  ##   $select: JString
  ##          : select specific fields in entity.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  var valid_594296 = query.getOrDefault("$top")
  valid_594296 = validateParameter(valid_594296, JInt, required = false, default = nil)
  if valid_594296 != nil:
    section.add "$top", valid_594296
  var valid_594297 = query.getOrDefault("$select")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "$select", valid_594297
  var valid_594298 = query.getOrDefault("$filter")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "$filter", valid_594298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594299: Call_GetMAMUserDevices_594290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get devices for a user.
  ## 
  let valid = call_594299.validator(path, query, header, formData, body)
  let scheme = call_594299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594299.url(scheme.get, call_594299.host, call_594299.base,
                         call_594299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594299, url, valid)

proc call*(call_594300: Call_GetMAMUserDevices_594290; apiVersion: string;
          hostName: string; userName: string; Top: int = 0; Select: string = "";
          Filter: string = ""): Recallable =
  ## getMAMUserDevices
  ## Get devices for a user.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : user unique Name
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594301 = newJObject()
  var query_594302 = newJObject()
  add(query_594302, "api-version", newJString(apiVersion))
  add(query_594302, "$top", newJInt(Top))
  add(query_594302, "$select", newJString(Select))
  add(path_594301, "hostName", newJString(hostName))
  add(path_594301, "userName", newJString(userName))
  add(query_594302, "$filter", newJString(Filter))
  result = call_594300.call(path_594301, query_594302, nil, nil, nil)

var getMAMUserDevices* = Call_GetMAMUserDevices_594290(name: "getMAMUserDevices",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices",
    validator: validate_GetMAMUserDevices_594291, base: "",
    url: url_GetMAMUserDevices_594292, schemes: {Scheme.Https})
type
  Call_GetMAMUserDeviceByDeviceName_594303 = ref object of OpenApiRestCall_593408
proc url_GetMAMUserDeviceByDeviceName_594305(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetMAMUserDeviceByDeviceName_594304(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a unique device for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   userName: JString (required)
  ##           : unique user name
  ##   deviceName: JString (required)
  ##             : device name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594306 = path.getOrDefault("hostName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "hostName", valid_594306
  var valid_594307 = path.getOrDefault("userName")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "userName", valid_594307
  var valid_594308 = path.getOrDefault("deviceName")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "deviceName", valid_594308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594309 = query.getOrDefault("api-version")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "api-version", valid_594309
  var valid_594310 = query.getOrDefault("$select")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "$select", valid_594310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594311: Call_GetMAMUserDeviceByDeviceName_594303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a unique device for a user.
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_GetMAMUserDeviceByDeviceName_594303;
          apiVersion: string; hostName: string; userName: string; deviceName: string;
          Select: string = ""): Recallable =
  ## getMAMUserDeviceByDeviceName
  ## Get a unique device for a user.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : unique user name
  ##   deviceName: string (required)
  ##             : device name
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  add(query_594314, "api-version", newJString(apiVersion))
  add(query_594314, "$select", newJString(Select))
  add(path_594313, "hostName", newJString(hostName))
  add(path_594313, "userName", newJString(userName))
  add(path_594313, "deviceName", newJString(deviceName))
  result = call_594312.call(path_594313, query_594314, nil, nil, nil)

var getMAMUserDeviceByDeviceName* = Call_GetMAMUserDeviceByDeviceName_594303(
    name: "getMAMUserDeviceByDeviceName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices/{deviceName}",
    validator: validate_GetMAMUserDeviceByDeviceName_594304, base: "",
    url: url_GetMAMUserDeviceByDeviceName_594305, schemes: {Scheme.Https})
type
  Call_WipeMAMUserDevice_594315 = ref object of OpenApiRestCall_593408
proc url_WipeMAMUserDevice_594317(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostName" in path, "`hostName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Intune/locations/"),
               (kind: VariableSegment, value: "hostName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/wipe")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WipeMAMUserDevice_594316(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Wipe a device for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   userName: JString (required)
  ##           : unique user name
  ##   deviceName: JString (required)
  ##             : device name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hostName` field"
  var valid_594318 = path.getOrDefault("hostName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "hostName", valid_594318
  var valid_594319 = path.getOrDefault("userName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "userName", valid_594319
  var valid_594320 = path.getOrDefault("deviceName")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "deviceName", valid_594320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594321 = query.getOrDefault("api-version")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "api-version", valid_594321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594322: Call_WipeMAMUserDevice_594315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Wipe a device for a user.
  ## 
  let valid = call_594322.validator(path, query, header, formData, body)
  let scheme = call_594322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594322.url(scheme.get, call_594322.host, call_594322.base,
                         call_594322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594322, url, valid)

proc call*(call_594323: Call_WipeMAMUserDevice_594315; apiVersion: string;
          hostName: string; userName: string; deviceName: string): Recallable =
  ## wipeMAMUserDevice
  ## Wipe a device for a user.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : unique user name
  ##   deviceName: string (required)
  ##             : device name
  var path_594324 = newJObject()
  var query_594325 = newJObject()
  add(query_594325, "api-version", newJString(apiVersion))
  add(path_594324, "hostName", newJString(hostName))
  add(path_594324, "userName", newJString(userName))
  add(path_594324, "deviceName", newJString(deviceName))
  result = call_594323.call(path_594324, query_594325, nil, nil, nil)

var wipeMAMUserDevice* = Call_WipeMAMUserDevice_594315(name: "wipeMAMUserDevice",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices/{deviceName}/wipe",
    validator: validate_WipeMAMUserDevice_594316, base: "",
    url: url_WipeMAMUserDevice_594317, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
