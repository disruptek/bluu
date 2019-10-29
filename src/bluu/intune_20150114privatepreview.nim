
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "intune"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetLocations_563761 = ref object of OpenApiRestCall_563539
proc url_GetLocations_563763(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetLocations_563762(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_563924 = query.getOrDefault("api-version")
  valid_563924 = validateParameter(valid_563924, JString, required = true,
                                 default = nil)
  if valid_563924 != nil:
    section.add "api-version", valid_563924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563947: Call_GetLocations_563761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns location for user tenant.
  ## 
  let valid = call_563947.validator(path, query, header, formData, body)
  let scheme = call_563947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563947.url(scheme.get, call_563947.host, call_563947.base,
                         call_563947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563947, url, valid)

proc call*(call_564018: Call_GetLocations_563761; apiVersion: string): Recallable =
  ## getLocations
  ## Returns location for user tenant.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  var query_564019 = newJObject()
  add(query_564019, "api-version", newJString(apiVersion))
  result = call_564018.call(nil, query_564019, nil, nil, nil)

var getLocations* = Call_GetLocations_563761(name: "getLocations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations",
    validator: validate_GetLocations_563762, base: "", url: url_GetLocations_563763,
    schemes: {Scheme.Https})
type
  Call_GetLocationByHostName_564059 = ref object of OpenApiRestCall_563539
proc url_GetLocationByHostName_564061(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetLocationByHostName_564060(path: JsonNode; query: JsonNode;
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
  var valid_564062 = query.getOrDefault("api-version")
  valid_564062 = validateParameter(valid_564062, JString, required = true,
                                 default = nil)
  if valid_564062 != nil:
    section.add "api-version", valid_564062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564063: Call_GetLocationByHostName_564059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns location for given tenant.
  ## 
  let valid = call_564063.validator(path, query, header, formData, body)
  let scheme = call_564063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564063.url(scheme.get, call_564063.host, call_564063.base,
                         call_564063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564063, url, valid)

proc call*(call_564064: Call_GetLocationByHostName_564059; apiVersion: string): Recallable =
  ## getLocationByHostName
  ## Returns location for given tenant.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  var query_564065 = newJObject()
  add(query_564065, "api-version", newJString(apiVersion))
  result = call_564064.call(nil, query_564065, nil, nil, nil)

var getLocationByHostName* = Call_GetLocationByHostName_564059(
    name: "getLocationByHostName", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/hostName",
    validator: validate_GetLocationByHostName_564060, base: "",
    url: url_GetLocationByHostName_564061, schemes: {Scheme.Https})
type
  Call_AndroidGetAppForMAMPolicy_564066 = ref object of OpenApiRestCall_563539
proc url_AndroidGetAppForMAMPolicy_564068(protocol: Scheme; host: string;
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

proc validate_AndroidGetAppForMAMPolicy_564067(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get apps for an AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564084 = path.getOrDefault("policyName")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "policyName", valid_564084
  var valid_564085 = path.getOrDefault("hostName")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "hostName", valid_564085
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
  var valid_564086 = query.getOrDefault("api-version")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "api-version", valid_564086
  var valid_564087 = query.getOrDefault("$top")
  valid_564087 = validateParameter(valid_564087, JInt, required = false, default = nil)
  if valid_564087 != nil:
    section.add "$top", valid_564087
  var valid_564088 = query.getOrDefault("$select")
  valid_564088 = validateParameter(valid_564088, JString, required = false,
                                 default = nil)
  if valid_564088 != nil:
    section.add "$select", valid_564088
  var valid_564089 = query.getOrDefault("$filter")
  valid_564089 = validateParameter(valid_564089, JString, required = false,
                                 default = nil)
  if valid_564089 != nil:
    section.add "$filter", valid_564089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564090: Call_AndroidGetAppForMAMPolicy_564066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get apps for an AndroidMAMPolicy.
  ## 
  let valid = call_564090.validator(path, query, header, formData, body)
  let scheme = call_564090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564090.url(scheme.get, call_564090.host, call_564090.base,
                         call_564090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564090, url, valid)

proc call*(call_564091: Call_AndroidGetAppForMAMPolicy_564066; policyName: string;
          apiVersion: string; hostName: string; Top: int = 0; Select: string = "";
          Filter: string = ""): Recallable =
  ## androidGetAppForMAMPolicy
  ## Get apps for an AndroidMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564092 = newJObject()
  var query_564093 = newJObject()
  add(path_564092, "policyName", newJString(policyName))
  add(query_564093, "api-version", newJString(apiVersion))
  add(query_564093, "$top", newJInt(Top))
  add(query_564093, "$select", newJString(Select))
  add(query_564093, "$filter", newJString(Filter))
  add(path_564092, "hostName", newJString(hostName))
  result = call_564091.call(path_564092, query_564093, nil, nil, nil)

var androidGetAppForMAMPolicy* = Call_AndroidGetAppForMAMPolicy_564066(
    name: "androidGetAppForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/AndroidPolicies/{policyName}/apps",
    validator: validate_AndroidGetAppForMAMPolicy_564067, base: "",
    url: url_AndroidGetAppForMAMPolicy_564068, schemes: {Scheme.Https})
type
  Call_AndroidGetMAMPolicies_564094 = ref object of OpenApiRestCall_563539
proc url_AndroidGetMAMPolicies_564096(protocol: Scheme; host: string; base: string;
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

proc validate_AndroidGetMAMPolicies_564095(path: JsonNode; query: JsonNode;
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
  var valid_564097 = path.getOrDefault("hostName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "hostName", valid_564097
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
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  var valid_564099 = query.getOrDefault("$top")
  valid_564099 = validateParameter(valid_564099, JInt, required = false, default = nil)
  if valid_564099 != nil:
    section.add "$top", valid_564099
  var valid_564100 = query.getOrDefault("$select")
  valid_564100 = validateParameter(valid_564100, JString, required = false,
                                 default = nil)
  if valid_564100 != nil:
    section.add "$select", valid_564100
  var valid_564101 = query.getOrDefault("$filter")
  valid_564101 = validateParameter(valid_564101, JString, required = false,
                                 default = nil)
  if valid_564101 != nil:
    section.add "$filter", valid_564101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564102: Call_AndroidGetMAMPolicies_564094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Android policies.
  ## 
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_AndroidGetMAMPolicies_564094; apiVersion: string;
          hostName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## androidGetMAMPolicies
  ## Returns Intune Android policies.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564104 = newJObject()
  var query_564105 = newJObject()
  add(query_564105, "api-version", newJString(apiVersion))
  add(query_564105, "$top", newJInt(Top))
  add(query_564105, "$select", newJString(Select))
  add(query_564105, "$filter", newJString(Filter))
  add(path_564104, "hostName", newJString(hostName))
  result = call_564103.call(path_564104, query_564105, nil, nil, nil)

var androidGetMAMPolicies* = Call_AndroidGetMAMPolicies_564094(
    name: "androidGetMAMPolicies", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies",
    validator: validate_AndroidGetMAMPolicies_564095, base: "",
    url: url_AndroidGetMAMPolicies_564096, schemes: {Scheme.Https})
type
  Call_AndroidCreateOrUpdateMAMPolicy_564117 = ref object of OpenApiRestCall_563539
proc url_AndroidCreateOrUpdateMAMPolicy_564119(protocol: Scheme; host: string;
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

proc validate_AndroidCreateOrUpdateMAMPolicy_564118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564137 = path.getOrDefault("policyName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "policyName", valid_564137
  var valid_564138 = path.getOrDefault("hostName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "hostName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
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

proc call*(call_564141: Call_AndroidCreateOrUpdateMAMPolicy_564117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates AndroidMAMPolicy.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_AndroidCreateOrUpdateMAMPolicy_564117;
          policyName: string; apiVersion: string; hostName: string;
          parameters: JsonNode): Recallable =
  ## androidCreateOrUpdateMAMPolicy
  ## Creates or updates AndroidMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  var body_564145 = newJObject()
  add(path_564143, "policyName", newJString(policyName))
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "hostName", newJString(hostName))
  if parameters != nil:
    body_564145 = parameters
  result = call_564142.call(path_564143, query_564144, nil, nil, body_564145)

var androidCreateOrUpdateMAMPolicy* = Call_AndroidCreateOrUpdateMAMPolicy_564117(
    name: "androidCreateOrUpdateMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidCreateOrUpdateMAMPolicy_564118, base: "",
    url: url_AndroidCreateOrUpdateMAMPolicy_564119, schemes: {Scheme.Https})
type
  Call_AndroidGetMAMPolicyByName_564106 = ref object of OpenApiRestCall_563539
proc url_AndroidGetMAMPolicyByName_564108(protocol: Scheme; host: string;
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

proc validate_AndroidGetMAMPolicyByName_564107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns AndroidMAMPolicy with given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564109 = path.getOrDefault("policyName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "policyName", valid_564109
  var valid_564110 = path.getOrDefault("hostName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "hostName", valid_564110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564111 = query.getOrDefault("api-version")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "api-version", valid_564111
  var valid_564112 = query.getOrDefault("$select")
  valid_564112 = validateParameter(valid_564112, JString, required = false,
                                 default = nil)
  if valid_564112 != nil:
    section.add "$select", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564113: Call_AndroidGetMAMPolicyByName_564106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns AndroidMAMPolicy with given name.
  ## 
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_AndroidGetMAMPolicyByName_564106; policyName: string;
          apiVersion: string; hostName: string; Select: string = ""): Recallable =
  ## androidGetMAMPolicyByName
  ## Returns AndroidMAMPolicy with given name.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564115 = newJObject()
  var query_564116 = newJObject()
  add(path_564115, "policyName", newJString(policyName))
  add(query_564116, "api-version", newJString(apiVersion))
  add(query_564116, "$select", newJString(Select))
  add(path_564115, "hostName", newJString(hostName))
  result = call_564114.call(path_564115, query_564116, nil, nil, nil)

var androidGetMAMPolicyByName* = Call_AndroidGetMAMPolicyByName_564106(
    name: "androidGetMAMPolicyByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidGetMAMPolicyByName_564107, base: "",
    url: url_AndroidGetMAMPolicyByName_564108, schemes: {Scheme.Https})
type
  Call_AndroidPatchMAMPolicy_564156 = ref object of OpenApiRestCall_563539
proc url_AndroidPatchMAMPolicy_564158(protocol: Scheme; host: string; base: string;
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

proc validate_AndroidPatchMAMPolicy_564157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564159 = path.getOrDefault("policyName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "policyName", valid_564159
  var valid_564160 = path.getOrDefault("hostName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "hostName", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "api-version", valid_564161
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

proc call*(call_564163: Call_AndroidPatchMAMPolicy_564156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch AndroidMAMPolicy.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_AndroidPatchMAMPolicy_564156; policyName: string;
          apiVersion: string; hostName: string; parameters: JsonNode): Recallable =
  ## androidPatchMAMPolicy
  ## Patch AndroidMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  var body_564167 = newJObject()
  add(path_564165, "policyName", newJString(policyName))
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "hostName", newJString(hostName))
  if parameters != nil:
    body_564167 = parameters
  result = call_564164.call(path_564165, query_564166, nil, nil, body_564167)

var androidPatchMAMPolicy* = Call_AndroidPatchMAMPolicy_564156(
    name: "androidPatchMAMPolicy", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidPatchMAMPolicy_564157, base: "",
    url: url_AndroidPatchMAMPolicy_564158, schemes: {Scheme.Https})
type
  Call_AndroidDeleteMAMPolicy_564146 = ref object of OpenApiRestCall_563539
proc url_AndroidDeleteMAMPolicy_564148(protocol: Scheme; host: string; base: string;
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

proc validate_AndroidDeleteMAMPolicy_564147(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Android Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564149 = path.getOrDefault("policyName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "policyName", valid_564149
  var valid_564150 = path.getOrDefault("hostName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "hostName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_AndroidDeleteMAMPolicy_564146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Android Policy
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_AndroidDeleteMAMPolicy_564146; policyName: string;
          apiVersion: string; hostName: string): Recallable =
  ## androidDeleteMAMPolicy
  ## Delete Android Policy
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(path_564154, "policyName", newJString(policyName))
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "hostName", newJString(hostName))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var androidDeleteMAMPolicy* = Call_AndroidDeleteMAMPolicy_564146(
    name: "androidDeleteMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidDeleteMAMPolicy_564147, base: "",
    url: url_AndroidDeleteMAMPolicy_564148, schemes: {Scheme.Https})
type
  Call_AndroidAddAppForMAMPolicy_564168 = ref object of OpenApiRestCall_563539
proc url_AndroidAddAppForMAMPolicy_564170(protocol: Scheme; host: string;
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

proc validate_AndroidAddAppForMAMPolicy_564169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add app to an AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   appName: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564171 = path.getOrDefault("policyName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "policyName", valid_564171
  var valid_564172 = path.getOrDefault("appName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "appName", valid_564172
  var valid_564173 = path.getOrDefault("hostName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "hostName", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
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

proc call*(call_564176: Call_AndroidAddAppForMAMPolicy_564168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add app to an AndroidMAMPolicy.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_AndroidAddAppForMAMPolicy_564168; policyName: string;
          apiVersion: string; appName: string; hostName: string; parameters: JsonNode): Recallable =
  ## androidAddAppForMAMPolicy
  ## Add app to an AndroidMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   appName: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  var body_564180 = newJObject()
  add(path_564178, "policyName", newJString(policyName))
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "appName", newJString(appName))
  add(path_564178, "hostName", newJString(hostName))
  if parameters != nil:
    body_564180 = parameters
  result = call_564177.call(path_564178, query_564179, nil, nil, body_564180)

var androidAddAppForMAMPolicy* = Call_AndroidAddAppForMAMPolicy_564168(
    name: "androidAddAppForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/apps/{appName}",
    validator: validate_AndroidAddAppForMAMPolicy_564169, base: "",
    url: url_AndroidAddAppForMAMPolicy_564170, schemes: {Scheme.Https})
type
  Call_AndroidDeleteAppForMAMPolicy_564181 = ref object of OpenApiRestCall_563539
proc url_AndroidDeleteAppForMAMPolicy_564183(protocol: Scheme; host: string;
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

proc validate_AndroidDeleteAppForMAMPolicy_564182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete App for Android Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   appName: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564184 = path.getOrDefault("policyName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "policyName", valid_564184
  var valid_564185 = path.getOrDefault("appName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "appName", valid_564185
  var valid_564186 = path.getOrDefault("hostName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "hostName", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_AndroidDeleteAppForMAMPolicy_564181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete App for Android Policy
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_AndroidDeleteAppForMAMPolicy_564181;
          policyName: string; apiVersion: string; appName: string; hostName: string): Recallable =
  ## androidDeleteAppForMAMPolicy
  ## Delete App for Android Policy
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   appName: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(path_564190, "policyName", newJString(policyName))
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "appName", newJString(appName))
  add(path_564190, "hostName", newJString(hostName))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var androidDeleteAppForMAMPolicy* = Call_AndroidDeleteAppForMAMPolicy_564181(
    name: "androidDeleteAppForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/apps/{appName}",
    validator: validate_AndroidDeleteAppForMAMPolicy_564182, base: "",
    url: url_AndroidDeleteAppForMAMPolicy_564183, schemes: {Scheme.Https})
type
  Call_AndroidGetGroupsForMAMPolicy_564192 = ref object of OpenApiRestCall_563539
proc url_AndroidGetGroupsForMAMPolicy_564194(protocol: Scheme; host: string;
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

proc validate_AndroidGetGroupsForMAMPolicy_564193(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns groups for a given AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : policy name for the tenant
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564195 = path.getOrDefault("policyName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "policyName", valid_564195
  var valid_564196 = path.getOrDefault("hostName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "hostName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_AndroidGetGroupsForMAMPolicy_564192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns groups for a given AndroidMAMPolicy.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_AndroidGetGroupsForMAMPolicy_564192;
          policyName: string; apiVersion: string; hostName: string): Recallable =
  ## androidGetGroupsForMAMPolicy
  ## Returns groups for a given AndroidMAMPolicy.
  ##   policyName: string (required)
  ##             : policy name for the tenant
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  add(path_564200, "policyName", newJString(policyName))
  add(query_564201, "api-version", newJString(apiVersion))
  add(path_564200, "hostName", newJString(hostName))
  result = call_564199.call(path_564200, query_564201, nil, nil, nil)

var androidGetGroupsForMAMPolicy* = Call_AndroidGetGroupsForMAMPolicy_564192(
    name: "androidGetGroupsForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups",
    validator: validate_AndroidGetGroupsForMAMPolicy_564193, base: "",
    url: url_AndroidGetGroupsForMAMPolicy_564194, schemes: {Scheme.Https})
type
  Call_AndroidAddGroupForMAMPolicy_564202 = ref object of OpenApiRestCall_563539
proc url_AndroidAddGroupForMAMPolicy_564204(protocol: Scheme; host: string;
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

proc validate_AndroidAddGroupForMAMPolicy_564203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add group to an AndroidMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   groupId: JString (required)
  ##          : group Id
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564205 = path.getOrDefault("policyName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "policyName", valid_564205
  var valid_564206 = path.getOrDefault("groupId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "groupId", valid_564206
  var valid_564207 = path.getOrDefault("hostName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "hostName", valid_564207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564208 = query.getOrDefault("api-version")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "api-version", valid_564208
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

proc call*(call_564210: Call_AndroidAddGroupForMAMPolicy_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add group to an AndroidMAMPolicy.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_AndroidAddGroupForMAMPolicy_564202;
          policyName: string; apiVersion: string; groupId: string; hostName: string;
          parameters: JsonNode): Recallable =
  ## androidAddGroupForMAMPolicy
  ## Add group to an AndroidMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   groupId: string (required)
  ##          : group Id
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  var body_564214 = newJObject()
  add(path_564212, "policyName", newJString(policyName))
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "groupId", newJString(groupId))
  add(path_564212, "hostName", newJString(hostName))
  if parameters != nil:
    body_564214 = parameters
  result = call_564211.call(path_564212, query_564213, nil, nil, body_564214)

var androidAddGroupForMAMPolicy* = Call_AndroidAddGroupForMAMPolicy_564202(
    name: "androidAddGroupForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups/{groupId}",
    validator: validate_AndroidAddGroupForMAMPolicy_564203, base: "",
    url: url_AndroidAddGroupForMAMPolicy_564204, schemes: {Scheme.Https})
type
  Call_AndroidDeleteGroupForMAMPolicy_564215 = ref object of OpenApiRestCall_563539
proc url_AndroidDeleteGroupForMAMPolicy_564217(protocol: Scheme; host: string;
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

proc validate_AndroidDeleteGroupForMAMPolicy_564216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Group for Android Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   groupId: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564218 = path.getOrDefault("policyName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "policyName", valid_564218
  var valid_564219 = path.getOrDefault("groupId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "groupId", valid_564219
  var valid_564220 = path.getOrDefault("hostName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "hostName", valid_564220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564222: Call_AndroidDeleteGroupForMAMPolicy_564215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group for Android Policy
  ## 
  let valid = call_564222.validator(path, query, header, formData, body)
  let scheme = call_564222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564222.url(scheme.get, call_564222.host, call_564222.base,
                         call_564222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564222, url, valid)

proc call*(call_564223: Call_AndroidDeleteGroupForMAMPolicy_564215;
          policyName: string; apiVersion: string; groupId: string; hostName: string): Recallable =
  ## androidDeleteGroupForMAMPolicy
  ## Delete Group for Android Policy
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   groupId: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564224 = newJObject()
  var query_564225 = newJObject()
  add(path_564224, "policyName", newJString(policyName))
  add(query_564225, "api-version", newJString(apiVersion))
  add(path_564224, "groupId", newJString(groupId))
  add(path_564224, "hostName", newJString(hostName))
  result = call_564223.call(path_564224, query_564225, nil, nil, nil)

var androidDeleteGroupForMAMPolicy* = Call_AndroidDeleteGroupForMAMPolicy_564215(
    name: "androidDeleteGroupForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups/{groupId}",
    validator: validate_AndroidDeleteGroupForMAMPolicy_564216, base: "",
    url: url_AndroidDeleteGroupForMAMPolicy_564217, schemes: {Scheme.Https})
type
  Call_GetApps_564226 = ref object of OpenApiRestCall_563539
proc url_GetApps_564228(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetApps_564227(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564229 = path.getOrDefault("hostName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "hostName", valid_564229
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
  var valid_564230 = query.getOrDefault("api-version")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "api-version", valid_564230
  var valid_564231 = query.getOrDefault("$top")
  valid_564231 = validateParameter(valid_564231, JInt, required = false, default = nil)
  if valid_564231 != nil:
    section.add "$top", valid_564231
  var valid_564232 = query.getOrDefault("$select")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "$select", valid_564232
  var valid_564233 = query.getOrDefault("$filter")
  valid_564233 = validateParameter(valid_564233, JString, required = false,
                                 default = nil)
  if valid_564233 != nil:
    section.add "$filter", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_GetApps_564226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Manageable apps.
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_GetApps_564226; apiVersion: string; hostName: string;
          Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## getApps
  ## Returns Intune Manageable apps.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(query_564237, "api-version", newJString(apiVersion))
  add(query_564237, "$top", newJInt(Top))
  add(query_564237, "$select", newJString(Select))
  add(query_564237, "$filter", newJString(Filter))
  add(path_564236, "hostName", newJString(hostName))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var getApps* = Call_GetApps_564226(name: "getApps", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/apps",
                                validator: validate_GetApps_564227, base: "",
                                url: url_GetApps_564228, schemes: {Scheme.Https})
type
  Call_GetMAMFlaggedUsers_564238 = ref object of OpenApiRestCall_563539
proc url_GetMAMFlaggedUsers_564240(protocol: Scheme; host: string; base: string;
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

proc validate_GetMAMFlaggedUsers_564239(path: JsonNode; query: JsonNode;
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
  var valid_564241 = path.getOrDefault("hostName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "hostName", valid_564241
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
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  var valid_564243 = query.getOrDefault("$top")
  valid_564243 = validateParameter(valid_564243, JInt, required = false, default = nil)
  if valid_564243 != nil:
    section.add "$top", valid_564243
  var valid_564244 = query.getOrDefault("$select")
  valid_564244 = validateParameter(valid_564244, JString, required = false,
                                 default = nil)
  if valid_564244 != nil:
    section.add "$select", valid_564244
  var valid_564245 = query.getOrDefault("$filter")
  valid_564245 = validateParameter(valid_564245, JString, required = false,
                                 default = nil)
  if valid_564245 != nil:
    section.add "$filter", valid_564245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564246: Call_GetMAMFlaggedUsers_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged user collection
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_GetMAMFlaggedUsers_564238; apiVersion: string;
          hostName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## getMAMFlaggedUsers
  ## Returns Intune flagged user collection
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564248 = newJObject()
  var query_564249 = newJObject()
  add(query_564249, "api-version", newJString(apiVersion))
  add(query_564249, "$top", newJInt(Top))
  add(query_564249, "$select", newJString(Select))
  add(query_564249, "$filter", newJString(Filter))
  add(path_564248, "hostName", newJString(hostName))
  result = call_564247.call(path_564248, query_564249, nil, nil, nil)

var getMAMFlaggedUsers* = Call_GetMAMFlaggedUsers_564238(
    name: "getMAMFlaggedUsers", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers",
    validator: validate_GetMAMFlaggedUsers_564239, base: "",
    url: url_GetMAMFlaggedUsers_564240, schemes: {Scheme.Https})
type
  Call_GetMAMFlaggedUserByName_564250 = ref object of OpenApiRestCall_563539
proc url_GetMAMFlaggedUserByName_564252(protocol: Scheme; host: string; base: string;
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

proc validate_GetMAMFlaggedUserByName_564251(path: JsonNode; query: JsonNode;
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
  var valid_564253 = path.getOrDefault("hostName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "hostName", valid_564253
  var valid_564254 = path.getOrDefault("userName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "userName", valid_564254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564255 = query.getOrDefault("api-version")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "api-version", valid_564255
  var valid_564256 = query.getOrDefault("$select")
  valid_564256 = validateParameter(valid_564256, JString, required = false,
                                 default = nil)
  if valid_564256 != nil:
    section.add "$select", valid_564256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564257: Call_GetMAMFlaggedUserByName_564250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged user details
  ## 
  let valid = call_564257.validator(path, query, header, formData, body)
  let scheme = call_564257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564257.url(scheme.get, call_564257.host, call_564257.base,
                         call_564257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564257, url, valid)

proc call*(call_564258: Call_GetMAMFlaggedUserByName_564250; apiVersion: string;
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
  var path_564259 = newJObject()
  var query_564260 = newJObject()
  add(query_564260, "api-version", newJString(apiVersion))
  add(query_564260, "$select", newJString(Select))
  add(path_564259, "hostName", newJString(hostName))
  add(path_564259, "userName", newJString(userName))
  result = call_564258.call(path_564259, query_564260, nil, nil, nil)

var getMAMFlaggedUserByName* = Call_GetMAMFlaggedUserByName_564250(
    name: "getMAMFlaggedUserByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers/{userName}",
    validator: validate_GetMAMFlaggedUserByName_564251, base: "",
    url: url_GetMAMFlaggedUserByName_564252, schemes: {Scheme.Https})
type
  Call_GetMAMUserFlaggedEnrolledApps_564261 = ref object of OpenApiRestCall_563539
proc url_GetMAMUserFlaggedEnrolledApps_564263(protocol: Scheme; host: string;
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

proc validate_GetMAMUserFlaggedEnrolledApps_564262(path: JsonNode; query: JsonNode;
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
  var valid_564264 = path.getOrDefault("hostName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "hostName", valid_564264
  var valid_564265 = path.getOrDefault("userName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "userName", valid_564265
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
  var valid_564266 = query.getOrDefault("api-version")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "api-version", valid_564266
  var valid_564267 = query.getOrDefault("$top")
  valid_564267 = validateParameter(valid_564267, JInt, required = false, default = nil)
  if valid_564267 != nil:
    section.add "$top", valid_564267
  var valid_564268 = query.getOrDefault("$select")
  valid_564268 = validateParameter(valid_564268, JString, required = false,
                                 default = nil)
  if valid_564268 != nil:
    section.add "$select", valid_564268
  var valid_564269 = query.getOrDefault("$filter")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "$filter", valid_564269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564270: Call_GetMAMUserFlaggedEnrolledApps_564261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged enrolled app collection for the User
  ## 
  let valid = call_564270.validator(path, query, header, formData, body)
  let scheme = call_564270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564270.url(scheme.get, call_564270.host, call_564270.base,
                         call_564270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564270, url, valid)

proc call*(call_564271: Call_GetMAMUserFlaggedEnrolledApps_564261;
          apiVersion: string; hostName: string; userName: string; Top: int = 0;
          Select: string = ""; Filter: string = ""): Recallable =
  ## getMAMUserFlaggedEnrolledApps
  ## Returns Intune flagged enrolled app collection for the User
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : User name for the tenant
  var path_564272 = newJObject()
  var query_564273 = newJObject()
  add(query_564273, "api-version", newJString(apiVersion))
  add(query_564273, "$top", newJInt(Top))
  add(query_564273, "$select", newJString(Select))
  add(query_564273, "$filter", newJString(Filter))
  add(path_564272, "hostName", newJString(hostName))
  add(path_564272, "userName", newJString(userName))
  result = call_564271.call(path_564272, query_564273, nil, nil, nil)

var getMAMUserFlaggedEnrolledApps* = Call_GetMAMUserFlaggedEnrolledApps_564261(
    name: "getMAMUserFlaggedEnrolledApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers/{userName}/flaggedEnrolledApps",
    validator: validate_GetMAMUserFlaggedEnrolledApps_564262, base: "",
    url: url_GetMAMUserFlaggedEnrolledApps_564263, schemes: {Scheme.Https})
type
  Call_IosGetMAMPolicies_564274 = ref object of OpenApiRestCall_563539
proc url_IosGetMAMPolicies_564276(protocol: Scheme; host: string; base: string;
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

proc validate_IosGetMAMPolicies_564275(path: JsonNode; query: JsonNode;
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
  var valid_564277 = path.getOrDefault("hostName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "hostName", valid_564277
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
  var valid_564278 = query.getOrDefault("api-version")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "api-version", valid_564278
  var valid_564279 = query.getOrDefault("$top")
  valid_564279 = validateParameter(valid_564279, JInt, required = false, default = nil)
  if valid_564279 != nil:
    section.add "$top", valid_564279
  var valid_564280 = query.getOrDefault("$select")
  valid_564280 = validateParameter(valid_564280, JString, required = false,
                                 default = nil)
  if valid_564280 != nil:
    section.add "$select", valid_564280
  var valid_564281 = query.getOrDefault("$filter")
  valid_564281 = validateParameter(valid_564281, JString, required = false,
                                 default = nil)
  if valid_564281 != nil:
    section.add "$filter", valid_564281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564282: Call_IosGetMAMPolicies_564274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune iOSPolicies.
  ## 
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_IosGetMAMPolicies_564274; apiVersion: string;
          hostName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## iosGetMAMPolicies
  ## Returns Intune iOSPolicies.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564284 = newJObject()
  var query_564285 = newJObject()
  add(query_564285, "api-version", newJString(apiVersion))
  add(query_564285, "$top", newJInt(Top))
  add(query_564285, "$select", newJString(Select))
  add(query_564285, "$filter", newJString(Filter))
  add(path_564284, "hostName", newJString(hostName))
  result = call_564283.call(path_564284, query_564285, nil, nil, nil)

var iosGetMAMPolicies* = Call_IosGetMAMPolicies_564274(name: "iosGetMAMPolicies",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies",
    validator: validate_IosGetMAMPolicies_564275, base: "",
    url: url_IosGetMAMPolicies_564276, schemes: {Scheme.Https})
type
  Call_IosCreateOrUpdateMAMPolicy_564297 = ref object of OpenApiRestCall_563539
proc url_IosCreateOrUpdateMAMPolicy_564299(protocol: Scheme; host: string;
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

proc validate_IosCreateOrUpdateMAMPolicy_564298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564300 = path.getOrDefault("policyName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "policyName", valid_564300
  var valid_564301 = path.getOrDefault("hostName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "hostName", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
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

proc call*(call_564304: Call_IosCreateOrUpdateMAMPolicy_564297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates iOSMAMPolicy.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_IosCreateOrUpdateMAMPolicy_564297; policyName: string;
          apiVersion: string; hostName: string; parameters: JsonNode): Recallable =
  ## iosCreateOrUpdateMAMPolicy
  ## Creates or updates iOSMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  var body_564308 = newJObject()
  add(path_564306, "policyName", newJString(policyName))
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "hostName", newJString(hostName))
  if parameters != nil:
    body_564308 = parameters
  result = call_564305.call(path_564306, query_564307, nil, nil, body_564308)

var iosCreateOrUpdateMAMPolicy* = Call_IosCreateOrUpdateMAMPolicy_564297(
    name: "iosCreateOrUpdateMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosCreateOrUpdateMAMPolicy_564298, base: "",
    url: url_IosCreateOrUpdateMAMPolicy_564299, schemes: {Scheme.Https})
type
  Call_IosGetMAMPolicyByName_564286 = ref object of OpenApiRestCall_563539
proc url_IosGetMAMPolicyByName_564288(protocol: Scheme; host: string; base: string;
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

proc validate_IosGetMAMPolicyByName_564287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Intune iOS policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564289 = path.getOrDefault("policyName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "policyName", valid_564289
  var valid_564290 = path.getOrDefault("hostName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "hostName", valid_564290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564291 = query.getOrDefault("api-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "api-version", valid_564291
  var valid_564292 = query.getOrDefault("$select")
  valid_564292 = validateParameter(valid_564292, JString, required = false,
                                 default = nil)
  if valid_564292 != nil:
    section.add "$select", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_IosGetMAMPolicyByName_564286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune iOS policies.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_IosGetMAMPolicyByName_564286; policyName: string;
          apiVersion: string; hostName: string; Select: string = ""): Recallable =
  ## iosGetMAMPolicyByName
  ## Returns Intune iOS policies.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Select: string
  ##         : select specific fields in entity.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(path_564295, "policyName", newJString(policyName))
  add(query_564296, "api-version", newJString(apiVersion))
  add(query_564296, "$select", newJString(Select))
  add(path_564295, "hostName", newJString(hostName))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var iosGetMAMPolicyByName* = Call_IosGetMAMPolicyByName_564286(
    name: "iosGetMAMPolicyByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosGetMAMPolicyByName_564287, base: "",
    url: url_IosGetMAMPolicyByName_564288, schemes: {Scheme.Https})
type
  Call_IosPatchMAMPolicy_564319 = ref object of OpenApiRestCall_563539
proc url_IosPatchMAMPolicy_564321(protocol: Scheme; host: string; base: string;
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

proc validate_IosPatchMAMPolicy_564320(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ##  patch an iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564322 = path.getOrDefault("policyName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "policyName", valid_564322
  var valid_564323 = path.getOrDefault("hostName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "hostName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "api-version", valid_564324
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

proc call*(call_564326: Call_IosPatchMAMPolicy_564319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  patch an iOSMAMPolicy.
  ## 
  let valid = call_564326.validator(path, query, header, formData, body)
  let scheme = call_564326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564326.url(scheme.get, call_564326.host, call_564326.base,
                         call_564326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564326, url, valid)

proc call*(call_564327: Call_IosPatchMAMPolicy_564319; policyName: string;
          apiVersion: string; hostName: string; parameters: JsonNode): Recallable =
  ## iosPatchMAMPolicy
  ##  patch an iOSMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update an android policy operation.
  var path_564328 = newJObject()
  var query_564329 = newJObject()
  var body_564330 = newJObject()
  add(path_564328, "policyName", newJString(policyName))
  add(query_564329, "api-version", newJString(apiVersion))
  add(path_564328, "hostName", newJString(hostName))
  if parameters != nil:
    body_564330 = parameters
  result = call_564327.call(path_564328, query_564329, nil, nil, body_564330)

var iosPatchMAMPolicy* = Call_IosPatchMAMPolicy_564319(name: "iosPatchMAMPolicy",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosPatchMAMPolicy_564320, base: "",
    url: url_IosPatchMAMPolicy_564321, schemes: {Scheme.Https})
type
  Call_IosDeleteMAMPolicy_564309 = ref object of OpenApiRestCall_563539
proc url_IosDeleteMAMPolicy_564311(protocol: Scheme; host: string; base: string;
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

proc validate_IosDeleteMAMPolicy_564310(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete Ios Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564312 = path.getOrDefault("policyName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "policyName", valid_564312
  var valid_564313 = path.getOrDefault("hostName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "hostName", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_IosDeleteMAMPolicy_564309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Ios Policy
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_IosDeleteMAMPolicy_564309; policyName: string;
          apiVersion: string; hostName: string): Recallable =
  ## iosDeleteMAMPolicy
  ## Delete Ios Policy
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(path_564317, "policyName", newJString(policyName))
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "hostName", newJString(hostName))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var iosDeleteMAMPolicy* = Call_IosDeleteMAMPolicy_564309(
    name: "iosDeleteMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosDeleteMAMPolicy_564310, base: "",
    url: url_IosDeleteMAMPolicy_564311, schemes: {Scheme.Https})
type
  Call_IosGetAppForMAMPolicy_564331 = ref object of OpenApiRestCall_563539
proc url_IosGetAppForMAMPolicy_564333(protocol: Scheme; host: string; base: string;
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

proc validate_IosGetAppForMAMPolicy_564332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get apps for an iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564334 = path.getOrDefault("policyName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "policyName", valid_564334
  var valid_564335 = path.getOrDefault("hostName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "hostName", valid_564335
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
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "api-version", valid_564336
  var valid_564337 = query.getOrDefault("$top")
  valid_564337 = validateParameter(valid_564337, JInt, required = false, default = nil)
  if valid_564337 != nil:
    section.add "$top", valid_564337
  var valid_564338 = query.getOrDefault("$select")
  valid_564338 = validateParameter(valid_564338, JString, required = false,
                                 default = nil)
  if valid_564338 != nil:
    section.add "$select", valid_564338
  var valid_564339 = query.getOrDefault("$filter")
  valid_564339 = validateParameter(valid_564339, JString, required = false,
                                 default = nil)
  if valid_564339 != nil:
    section.add "$filter", valid_564339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564340: Call_IosGetAppForMAMPolicy_564331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get apps for an iOSMAMPolicy.
  ## 
  let valid = call_564340.validator(path, query, header, formData, body)
  let scheme = call_564340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564340.url(scheme.get, call_564340.host, call_564340.base,
                         call_564340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564340, url, valid)

proc call*(call_564341: Call_IosGetAppForMAMPolicy_564331; policyName: string;
          apiVersion: string; hostName: string; Top: int = 0; Select: string = "";
          Filter: string = ""): Recallable =
  ## iosGetAppForMAMPolicy
  ## Get apps for an iOSMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564342 = newJObject()
  var query_564343 = newJObject()
  add(path_564342, "policyName", newJString(policyName))
  add(query_564343, "api-version", newJString(apiVersion))
  add(query_564343, "$top", newJInt(Top))
  add(query_564343, "$select", newJString(Select))
  add(query_564343, "$filter", newJString(Filter))
  add(path_564342, "hostName", newJString(hostName))
  result = call_564341.call(path_564342, query_564343, nil, nil, nil)

var iosGetAppForMAMPolicy* = Call_IosGetAppForMAMPolicy_564331(
    name: "iosGetAppForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps",
    validator: validate_IosGetAppForMAMPolicy_564332, base: "",
    url: url_IosGetAppForMAMPolicy_564333, schemes: {Scheme.Https})
type
  Call_IosAddAppForMAMPolicy_564344 = ref object of OpenApiRestCall_563539
proc url_IosAddAppForMAMPolicy_564346(protocol: Scheme; host: string; base: string;
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

proc validate_IosAddAppForMAMPolicy_564345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add app to an iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   appName: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564347 = path.getOrDefault("policyName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "policyName", valid_564347
  var valid_564348 = path.getOrDefault("appName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "appName", valid_564348
  var valid_564349 = path.getOrDefault("hostName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "hostName", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
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

proc call*(call_564352: Call_IosAddAppForMAMPolicy_564344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add app to an iOSMAMPolicy.
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_IosAddAppForMAMPolicy_564344; policyName: string;
          apiVersion: string; appName: string; hostName: string; parameters: JsonNode): Recallable =
  ## iosAddAppForMAMPolicy
  ## Add app to an iOSMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   appName: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add an app to an ios policy.
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  var body_564356 = newJObject()
  add(path_564354, "policyName", newJString(policyName))
  add(query_564355, "api-version", newJString(apiVersion))
  add(path_564354, "appName", newJString(appName))
  add(path_564354, "hostName", newJString(hostName))
  if parameters != nil:
    body_564356 = parameters
  result = call_564353.call(path_564354, query_564355, nil, nil, body_564356)

var iosAddAppForMAMPolicy* = Call_IosAddAppForMAMPolicy_564344(
    name: "iosAddAppForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps/{appName}",
    validator: validate_IosAddAppForMAMPolicy_564345, base: "",
    url: url_IosAddAppForMAMPolicy_564346, schemes: {Scheme.Https})
type
  Call_IosDeleteAppForMAMPolicy_564357 = ref object of OpenApiRestCall_563539
proc url_IosDeleteAppForMAMPolicy_564359(protocol: Scheme; host: string;
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

proc validate_IosDeleteAppForMAMPolicy_564358(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete App for Ios Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   appName: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564360 = path.getOrDefault("policyName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "policyName", valid_564360
  var valid_564361 = path.getOrDefault("appName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "appName", valid_564361
  var valid_564362 = path.getOrDefault("hostName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "hostName", valid_564362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564363 = query.getOrDefault("api-version")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "api-version", valid_564363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564364: Call_IosDeleteAppForMAMPolicy_564357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete App for Ios Policy
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_IosDeleteAppForMAMPolicy_564357; policyName: string;
          apiVersion: string; appName: string; hostName: string): Recallable =
  ## iosDeleteAppForMAMPolicy
  ## Delete App for Ios Policy
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   appName: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  add(path_564366, "policyName", newJString(policyName))
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "appName", newJString(appName))
  add(path_564366, "hostName", newJString(hostName))
  result = call_564365.call(path_564366, query_564367, nil, nil, nil)

var iosDeleteAppForMAMPolicy* = Call_IosDeleteAppForMAMPolicy_564357(
    name: "iosDeleteAppForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps/{appName}",
    validator: validate_IosDeleteAppForMAMPolicy_564358, base: "",
    url: url_IosDeleteAppForMAMPolicy_564359, schemes: {Scheme.Https})
type
  Call_IosGetGroupsForMAMPolicy_564368 = ref object of OpenApiRestCall_563539
proc url_IosGetGroupsForMAMPolicy_564370(protocol: Scheme; host: string;
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

proc validate_IosGetGroupsForMAMPolicy_564369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns groups for a given iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : policy name for the tenant
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564371 = path.getOrDefault("policyName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "policyName", valid_564371
  var valid_564372 = path.getOrDefault("hostName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "hostName", valid_564372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564373 = query.getOrDefault("api-version")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "api-version", valid_564373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564374: Call_IosGetGroupsForMAMPolicy_564368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns groups for a given iOSMAMPolicy.
  ## 
  let valid = call_564374.validator(path, query, header, formData, body)
  let scheme = call_564374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564374.url(scheme.get, call_564374.host, call_564374.base,
                         call_564374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564374, url, valid)

proc call*(call_564375: Call_IosGetGroupsForMAMPolicy_564368; policyName: string;
          apiVersion: string; hostName: string): Recallable =
  ## iosGetGroupsForMAMPolicy
  ## Returns groups for a given iOSMAMPolicy.
  ##   policyName: string (required)
  ##             : policy name for the tenant
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564376 = newJObject()
  var query_564377 = newJObject()
  add(path_564376, "policyName", newJString(policyName))
  add(query_564377, "api-version", newJString(apiVersion))
  add(path_564376, "hostName", newJString(hostName))
  result = call_564375.call(path_564376, query_564377, nil, nil, nil)

var iosGetGroupsForMAMPolicy* = Call_IosGetGroupsForMAMPolicy_564368(
    name: "iosGetGroupsForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups",
    validator: validate_IosGetGroupsForMAMPolicy_564369, base: "",
    url: url_IosGetGroupsForMAMPolicy_564370, schemes: {Scheme.Https})
type
  Call_IosAddGroupForMAMPolicy_564378 = ref object of OpenApiRestCall_563539
proc url_IosAddGroupForMAMPolicy_564380(protocol: Scheme; host: string; base: string;
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

proc validate_IosAddGroupForMAMPolicy_564379(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add group to an iOSMAMPolicy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   groupId: JString (required)
  ##          : group Id
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564381 = path.getOrDefault("policyName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "policyName", valid_564381
  var valid_564382 = path.getOrDefault("groupId")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "groupId", valid_564382
  var valid_564383 = path.getOrDefault("hostName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "hostName", valid_564383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564384 = query.getOrDefault("api-version")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "api-version", valid_564384
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

proc call*(call_564386: Call_IosAddGroupForMAMPolicy_564378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add group to an iOSMAMPolicy.
  ## 
  let valid = call_564386.validator(path, query, header, formData, body)
  let scheme = call_564386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564386.url(scheme.get, call_564386.host, call_564386.base,
                         call_564386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564386, url, valid)

proc call*(call_564387: Call_IosAddGroupForMAMPolicy_564378; policyName: string;
          apiVersion: string; groupId: string; hostName: string; parameters: JsonNode): Recallable =
  ## iosAddGroupForMAMPolicy
  ## Add group to an iOSMAMPolicy.
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   groupId: string (required)
  ##          : group Id
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or update app to an android policy operation.
  var path_564388 = newJObject()
  var query_564389 = newJObject()
  var body_564390 = newJObject()
  add(path_564388, "policyName", newJString(policyName))
  add(query_564389, "api-version", newJString(apiVersion))
  add(path_564388, "groupId", newJString(groupId))
  add(path_564388, "hostName", newJString(hostName))
  if parameters != nil:
    body_564390 = parameters
  result = call_564387.call(path_564388, query_564389, nil, nil, body_564390)

var iosAddGroupForMAMPolicy* = Call_IosAddGroupForMAMPolicy_564378(
    name: "iosAddGroupForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups/{groupId}",
    validator: validate_IosAddGroupForMAMPolicy_564379, base: "",
    url: url_IosAddGroupForMAMPolicy_564380, schemes: {Scheme.Https})
type
  Call_IosDeleteGroupForMAMPolicy_564391 = ref object of OpenApiRestCall_563539
proc url_IosDeleteGroupForMAMPolicy_564393(protocol: Scheme; host: string;
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

proc validate_IosDeleteGroupForMAMPolicy_564392(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Group for iOS Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Unique name for the policy
  ##   groupId: JString (required)
  ##          : application unique Name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564394 = path.getOrDefault("policyName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "policyName", valid_564394
  var valid_564395 = path.getOrDefault("groupId")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "groupId", valid_564395
  var valid_564396 = path.getOrDefault("hostName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "hostName", valid_564396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564397 = query.getOrDefault("api-version")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "api-version", valid_564397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564398: Call_IosDeleteGroupForMAMPolicy_564391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group for iOS Policy
  ## 
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_IosDeleteGroupForMAMPolicy_564391; policyName: string;
          apiVersion: string; groupId: string; hostName: string): Recallable =
  ## iosDeleteGroupForMAMPolicy
  ## Delete Group for iOS Policy
  ##   policyName: string (required)
  ##             : Unique name for the policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   groupId: string (required)
  ##          : application unique Name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  add(path_564400, "policyName", newJString(policyName))
  add(query_564401, "api-version", newJString(apiVersion))
  add(path_564400, "groupId", newJString(groupId))
  add(path_564400, "hostName", newJString(hostName))
  result = call_564399.call(path_564400, query_564401, nil, nil, nil)

var iosDeleteGroupForMAMPolicy* = Call_IosDeleteGroupForMAMPolicy_564391(
    name: "iosDeleteGroupForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups/{groupId}",
    validator: validate_IosDeleteGroupForMAMPolicy_564392, base: "",
    url: url_IosDeleteGroupForMAMPolicy_564393, schemes: {Scheme.Https})
type
  Call_GetOperationResults_564402 = ref object of OpenApiRestCall_563539
proc url_GetOperationResults_564404(protocol: Scheme; host: string; base: string;
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

proc validate_GetOperationResults_564403(path: JsonNode; query: JsonNode;
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
  var valid_564405 = path.getOrDefault("hostName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "hostName", valid_564405
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
  var valid_564406 = query.getOrDefault("api-version")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "api-version", valid_564406
  var valid_564407 = query.getOrDefault("$top")
  valid_564407 = validateParameter(valid_564407, JInt, required = false, default = nil)
  if valid_564407 != nil:
    section.add "$top", valid_564407
  var valid_564408 = query.getOrDefault("$select")
  valid_564408 = validateParameter(valid_564408, JString, required = false,
                                 default = nil)
  if valid_564408 != nil:
    section.add "$select", valid_564408
  var valid_564409 = query.getOrDefault("$filter")
  valid_564409 = validateParameter(valid_564409, JString, required = false,
                                 default = nil)
  if valid_564409 != nil:
    section.add "$filter", valid_564409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564410: Call_GetOperationResults_564402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns operationResults.
  ## 
  let valid = call_564410.validator(path, query, header, formData, body)
  let scheme = call_564410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564410.url(scheme.get, call_564410.host, call_564410.base,
                         call_564410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564410, url, valid)

proc call*(call_564411: Call_GetOperationResults_564402; apiVersion: string;
          hostName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## getOperationResults
  ## Returns operationResults.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564412 = newJObject()
  var query_564413 = newJObject()
  add(query_564413, "api-version", newJString(apiVersion))
  add(query_564413, "$top", newJInt(Top))
  add(query_564413, "$select", newJString(Select))
  add(query_564413, "$filter", newJString(Filter))
  add(path_564412, "hostName", newJString(hostName))
  result = call_564411.call(path_564412, query_564413, nil, nil, nil)

var getOperationResults* = Call_GetOperationResults_564402(
    name: "getOperationResults", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/operationResults",
    validator: validate_GetOperationResults_564403, base: "",
    url: url_GetOperationResults_564404, schemes: {Scheme.Https})
type
  Call_GetMAMStatuses_564414 = ref object of OpenApiRestCall_563539
proc url_GetMAMStatuses_564416(protocol: Scheme; host: string; base: string;
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

proc validate_GetMAMStatuses_564415(path: JsonNode; query: JsonNode;
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
  var valid_564417 = path.getOrDefault("hostName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "hostName", valid_564417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564418 = query.getOrDefault("api-version")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "api-version", valid_564418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564419: Call_GetMAMStatuses_564414; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Tenant level statuses.
  ## 
  let valid = call_564419.validator(path, query, header, formData, body)
  let scheme = call_564419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564419.url(scheme.get, call_564419.host, call_564419.base,
                         call_564419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564419, url, valid)

proc call*(call_564420: Call_GetMAMStatuses_564414; apiVersion: string;
          hostName: string): Recallable =
  ## getMAMStatuses
  ## Returns Intune Tenant level statuses.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_564421 = newJObject()
  var query_564422 = newJObject()
  add(query_564422, "api-version", newJString(apiVersion))
  add(path_564421, "hostName", newJString(hostName))
  result = call_564420.call(path_564421, query_564422, nil, nil, nil)

var getMAMStatuses* = Call_GetMAMStatuses_564414(name: "getMAMStatuses",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/statuses/default",
    validator: validate_GetMAMStatuses_564415, base: "", url: url_GetMAMStatuses_564416,
    schemes: {Scheme.Https})
type
  Call_GetMAMUserDevices_564423 = ref object of OpenApiRestCall_563539
proc url_GetMAMUserDevices_564425(protocol: Scheme; host: string; base: string;
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

proc validate_GetMAMUserDevices_564424(path: JsonNode; query: JsonNode;
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
  var valid_564426 = path.getOrDefault("hostName")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "hostName", valid_564426
  var valid_564427 = path.getOrDefault("userName")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "userName", valid_564427
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
  var valid_564428 = query.getOrDefault("api-version")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "api-version", valid_564428
  var valid_564429 = query.getOrDefault("$top")
  valid_564429 = validateParameter(valid_564429, JInt, required = false, default = nil)
  if valid_564429 != nil:
    section.add "$top", valid_564429
  var valid_564430 = query.getOrDefault("$select")
  valid_564430 = validateParameter(valid_564430, JString, required = false,
                                 default = nil)
  if valid_564430 != nil:
    section.add "$select", valid_564430
  var valid_564431 = query.getOrDefault("$filter")
  valid_564431 = validateParameter(valid_564431, JString, required = false,
                                 default = nil)
  if valid_564431 != nil:
    section.add "$filter", valid_564431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564432: Call_GetMAMUserDevices_564423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get devices for a user.
  ## 
  let valid = call_564432.validator(path, query, header, formData, body)
  let scheme = call_564432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564432.url(scheme.get, call_564432.host, call_564432.base,
                         call_564432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564432, url, valid)

proc call*(call_564433: Call_GetMAMUserDevices_564423; apiVersion: string;
          hostName: string; userName: string; Top: int = 0; Select: string = "";
          Filter: string = ""): Recallable =
  ## getMAMUserDevices
  ## Get devices for a user.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Top: int
  ##   Select: string
  ##         : select specific fields in entity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : user unique Name
  var path_564434 = newJObject()
  var query_564435 = newJObject()
  add(query_564435, "api-version", newJString(apiVersion))
  add(query_564435, "$top", newJInt(Top))
  add(query_564435, "$select", newJString(Select))
  add(query_564435, "$filter", newJString(Filter))
  add(path_564434, "hostName", newJString(hostName))
  add(path_564434, "userName", newJString(userName))
  result = call_564433.call(path_564434, query_564435, nil, nil, nil)

var getMAMUserDevices* = Call_GetMAMUserDevices_564423(name: "getMAMUserDevices",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices",
    validator: validate_GetMAMUserDevices_564424, base: "",
    url: url_GetMAMUserDevices_564425, schemes: {Scheme.Https})
type
  Call_GetMAMUserDeviceByDeviceName_564436 = ref object of OpenApiRestCall_563539
proc url_GetMAMUserDeviceByDeviceName_564438(protocol: Scheme; host: string;
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

proc validate_GetMAMUserDeviceByDeviceName_564437(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a unique device for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceName: JString (required)
  ##             : device name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   userName: JString (required)
  ##           : unique user name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deviceName` field"
  var valid_564439 = path.getOrDefault("deviceName")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "deviceName", valid_564439
  var valid_564440 = path.getOrDefault("hostName")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "hostName", valid_564440
  var valid_564441 = path.getOrDefault("userName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "userName", valid_564441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564442 = query.getOrDefault("api-version")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "api-version", valid_564442
  var valid_564443 = query.getOrDefault("$select")
  valid_564443 = validateParameter(valid_564443, JString, required = false,
                                 default = nil)
  if valid_564443 != nil:
    section.add "$select", valid_564443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564444: Call_GetMAMUserDeviceByDeviceName_564436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a unique device for a user.
  ## 
  let valid = call_564444.validator(path, query, header, formData, body)
  let scheme = call_564444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564444.url(scheme.get, call_564444.host, call_564444.base,
                         call_564444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564444, url, valid)

proc call*(call_564445: Call_GetMAMUserDeviceByDeviceName_564436;
          apiVersion: string; deviceName: string; hostName: string; userName: string;
          Select: string = ""): Recallable =
  ## getMAMUserDeviceByDeviceName
  ## Get a unique device for a user.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   Select: string
  ##         : select specific fields in entity.
  ##   deviceName: string (required)
  ##             : device name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : unique user name
  var path_564446 = newJObject()
  var query_564447 = newJObject()
  add(query_564447, "api-version", newJString(apiVersion))
  add(query_564447, "$select", newJString(Select))
  add(path_564446, "deviceName", newJString(deviceName))
  add(path_564446, "hostName", newJString(hostName))
  add(path_564446, "userName", newJString(userName))
  result = call_564445.call(path_564446, query_564447, nil, nil, nil)

var getMAMUserDeviceByDeviceName* = Call_GetMAMUserDeviceByDeviceName_564436(
    name: "getMAMUserDeviceByDeviceName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices/{deviceName}",
    validator: validate_GetMAMUserDeviceByDeviceName_564437, base: "",
    url: url_GetMAMUserDeviceByDeviceName_564438, schemes: {Scheme.Https})
type
  Call_WipeMAMUserDevice_564448 = ref object of OpenApiRestCall_563539
proc url_WipeMAMUserDevice_564450(protocol: Scheme; host: string; base: string;
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

proc validate_WipeMAMUserDevice_564449(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Wipe a device for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceName: JString (required)
  ##             : device name
  ##   hostName: JString (required)
  ##           : Location hostName for the tenant
  ##   userName: JString (required)
  ##           : unique user name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deviceName` field"
  var valid_564451 = path.getOrDefault("deviceName")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "deviceName", valid_564451
  var valid_564452 = path.getOrDefault("hostName")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "hostName", valid_564452
  var valid_564453 = path.getOrDefault("userName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "userName", valid_564453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564454 = query.getOrDefault("api-version")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "api-version", valid_564454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564455: Call_WipeMAMUserDevice_564448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Wipe a device for a user.
  ## 
  let valid = call_564455.validator(path, query, header, formData, body)
  let scheme = call_564455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564455.url(scheme.get, call_564455.host, call_564455.base,
                         call_564455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564455, url, valid)

proc call*(call_564456: Call_WipeMAMUserDevice_564448; apiVersion: string;
          deviceName: string; hostName: string; userName: string): Recallable =
  ## wipeMAMUserDevice
  ## Wipe a device for a user.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   deviceName: string (required)
  ##             : device name
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   userName: string (required)
  ##           : unique user name
  var path_564457 = newJObject()
  var query_564458 = newJObject()
  add(query_564458, "api-version", newJString(apiVersion))
  add(path_564457, "deviceName", newJString(deviceName))
  add(path_564457, "hostName", newJString(hostName))
  add(path_564457, "userName", newJString(userName))
  result = call_564456.call(path_564457, query_564458, nil, nil, nil)

var wipeMAMUserDevice* = Call_WipeMAMUserDevice_564448(name: "wipeMAMUserDevice",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices/{deviceName}/wipe",
    validator: validate_WipeMAMUserDevice_564449, base: "",
    url: url_WipeMAMUserDevice_564450, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
