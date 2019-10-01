
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: IntuneResourceManagementClient
## version: 2015-01-14-preview
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "intune"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetLocations_567863 = ref object of OpenApiRestCall_567641
proc url_GetLocations_567865(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetLocations_567864(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_GetLocations_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns location for user tenant.
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_GetLocations_567863; apiVersion: string): Recallable =
  ## getLocations
  ## Returns location for user tenant.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var getLocations* = Call_GetLocations_567863(name: "getLocations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations",
    validator: validate_GetLocations_567864, base: "", url: url_GetLocations_567865,
    schemes: {Scheme.Https})
type
  Call_GetLocationByHostName_568159 = ref object of OpenApiRestCall_567641
proc url_GetLocationByHostName_568161(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetLocationByHostName_568160(path: JsonNode; query: JsonNode;
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
  var valid_568162 = query.getOrDefault("api-version")
  valid_568162 = validateParameter(valid_568162, JString, required = true,
                                 default = nil)
  if valid_568162 != nil:
    section.add "api-version", valid_568162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568163: Call_GetLocationByHostName_568159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns location for given tenant.
  ## 
  let valid = call_568163.validator(path, query, header, formData, body)
  let scheme = call_568163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568163.url(scheme.get, call_568163.host, call_568163.base,
                         call_568163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568163, url, valid)

proc call*(call_568164: Call_GetLocationByHostName_568159; apiVersion: string): Recallable =
  ## getLocationByHostName
  ## Returns location for given tenant.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  var query_568165 = newJObject()
  add(query_568165, "api-version", newJString(apiVersion))
  result = call_568164.call(nil, query_568165, nil, nil, nil)

var getLocationByHostName* = Call_GetLocationByHostName_568159(
    name: "getLocationByHostName", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/hostName",
    validator: validate_GetLocationByHostName_568160, base: "",
    url: url_GetLocationByHostName_568161, schemes: {Scheme.Https})
type
  Call_AndroidGetAppForMAMPolicy_568166 = ref object of OpenApiRestCall_567641
proc url_AndroidGetAppForMAMPolicy_568168(protocol: Scheme; host: string;
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

proc validate_AndroidGetAppForMAMPolicy_568167(path: JsonNode; query: JsonNode;
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
  var valid_568184 = path.getOrDefault("hostName")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "hostName", valid_568184
  var valid_568185 = path.getOrDefault("policyName")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "policyName", valid_568185
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
  var valid_568186 = query.getOrDefault("api-version")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "api-version", valid_568186
  var valid_568187 = query.getOrDefault("$top")
  valid_568187 = validateParameter(valid_568187, JInt, required = false, default = nil)
  if valid_568187 != nil:
    section.add "$top", valid_568187
  var valid_568188 = query.getOrDefault("$select")
  valid_568188 = validateParameter(valid_568188, JString, required = false,
                                 default = nil)
  if valid_568188 != nil:
    section.add "$select", valid_568188
  var valid_568189 = query.getOrDefault("$filter")
  valid_568189 = validateParameter(valid_568189, JString, required = false,
                                 default = nil)
  if valid_568189 != nil:
    section.add "$filter", valid_568189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_AndroidGetAppForMAMPolicy_568166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get apps for an AndroidMAMPolicy.
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_AndroidGetAppForMAMPolicy_568166; apiVersion: string;
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
  var path_568192 = newJObject()
  var query_568193 = newJObject()
  add(query_568193, "api-version", newJString(apiVersion))
  add(query_568193, "$top", newJInt(Top))
  add(query_568193, "$select", newJString(Select))
  add(path_568192, "hostName", newJString(hostName))
  add(path_568192, "policyName", newJString(policyName))
  add(query_568193, "$filter", newJString(Filter))
  result = call_568191.call(path_568192, query_568193, nil, nil, nil)

var androidGetAppForMAMPolicy* = Call_AndroidGetAppForMAMPolicy_568166(
    name: "androidGetAppForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/AndroidPolicies/{policyName}/apps",
    validator: validate_AndroidGetAppForMAMPolicy_568167, base: "",
    url: url_AndroidGetAppForMAMPolicy_568168, schemes: {Scheme.Https})
type
  Call_AndroidGetMAMPolicies_568194 = ref object of OpenApiRestCall_567641
proc url_AndroidGetMAMPolicies_568196(protocol: Scheme; host: string; base: string;
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

proc validate_AndroidGetMAMPolicies_568195(path: JsonNode; query: JsonNode;
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
  var valid_568197 = path.getOrDefault("hostName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "hostName", valid_568197
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
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  var valid_568199 = query.getOrDefault("$top")
  valid_568199 = validateParameter(valid_568199, JInt, required = false, default = nil)
  if valid_568199 != nil:
    section.add "$top", valid_568199
  var valid_568200 = query.getOrDefault("$select")
  valid_568200 = validateParameter(valid_568200, JString, required = false,
                                 default = nil)
  if valid_568200 != nil:
    section.add "$select", valid_568200
  var valid_568201 = query.getOrDefault("$filter")
  valid_568201 = validateParameter(valid_568201, JString, required = false,
                                 default = nil)
  if valid_568201 != nil:
    section.add "$filter", valid_568201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_AndroidGetMAMPolicies_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Android policies.
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_AndroidGetMAMPolicies_568194; apiVersion: string;
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
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  add(query_568205, "api-version", newJString(apiVersion))
  add(query_568205, "$top", newJInt(Top))
  add(query_568205, "$select", newJString(Select))
  add(path_568204, "hostName", newJString(hostName))
  add(query_568205, "$filter", newJString(Filter))
  result = call_568203.call(path_568204, query_568205, nil, nil, nil)

var androidGetMAMPolicies* = Call_AndroidGetMAMPolicies_568194(
    name: "androidGetMAMPolicies", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies",
    validator: validate_AndroidGetMAMPolicies_568195, base: "",
    url: url_AndroidGetMAMPolicies_568196, schemes: {Scheme.Https})
type
  Call_AndroidCreateOrUpdateMAMPolicy_568217 = ref object of OpenApiRestCall_567641
proc url_AndroidCreateOrUpdateMAMPolicy_568219(protocol: Scheme; host: string;
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

proc validate_AndroidCreateOrUpdateMAMPolicy_568218(path: JsonNode;
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
  var valid_568237 = path.getOrDefault("hostName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "hostName", valid_568237
  var valid_568238 = path.getOrDefault("policyName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "policyName", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
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

proc call*(call_568241: Call_AndroidCreateOrUpdateMAMPolicy_568217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates AndroidMAMPolicy.
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_AndroidCreateOrUpdateMAMPolicy_568217;
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
  var path_568243 = newJObject()
  var query_568244 = newJObject()
  var body_568245 = newJObject()
  add(query_568244, "api-version", newJString(apiVersion))
  add(path_568243, "hostName", newJString(hostName))
  add(path_568243, "policyName", newJString(policyName))
  if parameters != nil:
    body_568245 = parameters
  result = call_568242.call(path_568243, query_568244, nil, nil, body_568245)

var androidCreateOrUpdateMAMPolicy* = Call_AndroidCreateOrUpdateMAMPolicy_568217(
    name: "androidCreateOrUpdateMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidCreateOrUpdateMAMPolicy_568218, base: "",
    url: url_AndroidCreateOrUpdateMAMPolicy_568219, schemes: {Scheme.Https})
type
  Call_AndroidGetMAMPolicyByName_568206 = ref object of OpenApiRestCall_567641
proc url_AndroidGetMAMPolicyByName_568208(protocol: Scheme; host: string;
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

proc validate_AndroidGetMAMPolicyByName_568207(path: JsonNode; query: JsonNode;
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
  var valid_568209 = path.getOrDefault("hostName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "hostName", valid_568209
  var valid_568210 = path.getOrDefault("policyName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "policyName", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  var valid_568212 = query.getOrDefault("$select")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = nil)
  if valid_568212 != nil:
    section.add "$select", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_AndroidGetMAMPolicyByName_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns AndroidMAMPolicy with given name.
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_AndroidGetMAMPolicyByName_568206; apiVersion: string;
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
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(query_568216, "$select", newJString(Select))
  add(path_568215, "hostName", newJString(hostName))
  add(path_568215, "policyName", newJString(policyName))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var androidGetMAMPolicyByName* = Call_AndroidGetMAMPolicyByName_568206(
    name: "androidGetMAMPolicyByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidGetMAMPolicyByName_568207, base: "",
    url: url_AndroidGetMAMPolicyByName_568208, schemes: {Scheme.Https})
type
  Call_AndroidPatchMAMPolicy_568256 = ref object of OpenApiRestCall_567641
proc url_AndroidPatchMAMPolicy_568258(protocol: Scheme; host: string; base: string;
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

proc validate_AndroidPatchMAMPolicy_568257(path: JsonNode; query: JsonNode;
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
  var valid_568259 = path.getOrDefault("hostName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "hostName", valid_568259
  var valid_568260 = path.getOrDefault("policyName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "policyName", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
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

proc call*(call_568263: Call_AndroidPatchMAMPolicy_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch AndroidMAMPolicy.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_AndroidPatchMAMPolicy_568256; apiVersion: string;
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
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  var body_568267 = newJObject()
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "hostName", newJString(hostName))
  add(path_568265, "policyName", newJString(policyName))
  if parameters != nil:
    body_568267 = parameters
  result = call_568264.call(path_568265, query_568266, nil, nil, body_568267)

var androidPatchMAMPolicy* = Call_AndroidPatchMAMPolicy_568256(
    name: "androidPatchMAMPolicy", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidPatchMAMPolicy_568257, base: "",
    url: url_AndroidPatchMAMPolicy_568258, schemes: {Scheme.Https})
type
  Call_AndroidDeleteMAMPolicy_568246 = ref object of OpenApiRestCall_567641
proc url_AndroidDeleteMAMPolicy_568248(protocol: Scheme; host: string; base: string;
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

proc validate_AndroidDeleteMAMPolicy_568247(path: JsonNode; query: JsonNode;
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
  var valid_568249 = path.getOrDefault("hostName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "hostName", valid_568249
  var valid_568250 = path.getOrDefault("policyName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "policyName", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_AndroidDeleteMAMPolicy_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Android Policy
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_AndroidDeleteMAMPolicy_568246; apiVersion: string;
          hostName: string; policyName: string): Recallable =
  ## androidDeleteMAMPolicy
  ## Delete Android Policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "hostName", newJString(hostName))
  add(path_568254, "policyName", newJString(policyName))
  result = call_568253.call(path_568254, query_568255, nil, nil, nil)

var androidDeleteMAMPolicy* = Call_AndroidDeleteMAMPolicy_568246(
    name: "androidDeleteMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}",
    validator: validate_AndroidDeleteMAMPolicy_568247, base: "",
    url: url_AndroidDeleteMAMPolicy_568248, schemes: {Scheme.Https})
type
  Call_AndroidAddAppForMAMPolicy_568268 = ref object of OpenApiRestCall_567641
proc url_AndroidAddAppForMAMPolicy_568270(protocol: Scheme; host: string;
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

proc validate_AndroidAddAppForMAMPolicy_568269(path: JsonNode; query: JsonNode;
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
  var valid_568271 = path.getOrDefault("appName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "appName", valid_568271
  var valid_568272 = path.getOrDefault("hostName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "hostName", valid_568272
  var valid_568273 = path.getOrDefault("policyName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "policyName", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
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

proc call*(call_568276: Call_AndroidAddAppForMAMPolicy_568268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add app to an AndroidMAMPolicy.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_AndroidAddAppForMAMPolicy_568268; apiVersion: string;
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
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  var body_568280 = newJObject()
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "appName", newJString(appName))
  add(path_568278, "hostName", newJString(hostName))
  add(path_568278, "policyName", newJString(policyName))
  if parameters != nil:
    body_568280 = parameters
  result = call_568277.call(path_568278, query_568279, nil, nil, body_568280)

var androidAddAppForMAMPolicy* = Call_AndroidAddAppForMAMPolicy_568268(
    name: "androidAddAppForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/apps/{appName}",
    validator: validate_AndroidAddAppForMAMPolicy_568269, base: "",
    url: url_AndroidAddAppForMAMPolicy_568270, schemes: {Scheme.Https})
type
  Call_AndroidDeleteAppForMAMPolicy_568281 = ref object of OpenApiRestCall_567641
proc url_AndroidDeleteAppForMAMPolicy_568283(protocol: Scheme; host: string;
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

proc validate_AndroidDeleteAppForMAMPolicy_568282(path: JsonNode; query: JsonNode;
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
  var valid_568284 = path.getOrDefault("appName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "appName", valid_568284
  var valid_568285 = path.getOrDefault("hostName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "hostName", valid_568285
  var valid_568286 = path.getOrDefault("policyName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "policyName", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_AndroidDeleteAppForMAMPolicy_568281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete App for Android Policy
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_AndroidDeleteAppForMAMPolicy_568281;
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
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "appName", newJString(appName))
  add(path_568290, "hostName", newJString(hostName))
  add(path_568290, "policyName", newJString(policyName))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var androidDeleteAppForMAMPolicy* = Call_AndroidDeleteAppForMAMPolicy_568281(
    name: "androidDeleteAppForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/apps/{appName}",
    validator: validate_AndroidDeleteAppForMAMPolicy_568282, base: "",
    url: url_AndroidDeleteAppForMAMPolicy_568283, schemes: {Scheme.Https})
type
  Call_AndroidGetGroupsForMAMPolicy_568292 = ref object of OpenApiRestCall_567641
proc url_AndroidGetGroupsForMAMPolicy_568294(protocol: Scheme; host: string;
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

proc validate_AndroidGetGroupsForMAMPolicy_568293(path: JsonNode; query: JsonNode;
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
  var valid_568295 = path.getOrDefault("hostName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "hostName", valid_568295
  var valid_568296 = path.getOrDefault("policyName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "policyName", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_AndroidGetGroupsForMAMPolicy_568292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns groups for a given AndroidMAMPolicy.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_AndroidGetGroupsForMAMPolicy_568292;
          apiVersion: string; hostName: string; policyName: string): Recallable =
  ## androidGetGroupsForMAMPolicy
  ## Returns groups for a given AndroidMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : policy name for the tenant
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "hostName", newJString(hostName))
  add(path_568300, "policyName", newJString(policyName))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var androidGetGroupsForMAMPolicy* = Call_AndroidGetGroupsForMAMPolicy_568292(
    name: "androidGetGroupsForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups",
    validator: validate_AndroidGetGroupsForMAMPolicy_568293, base: "",
    url: url_AndroidGetGroupsForMAMPolicy_568294, schemes: {Scheme.Https})
type
  Call_AndroidAddGroupForMAMPolicy_568302 = ref object of OpenApiRestCall_567641
proc url_AndroidAddGroupForMAMPolicy_568304(protocol: Scheme; host: string;
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

proc validate_AndroidAddGroupForMAMPolicy_568303(path: JsonNode; query: JsonNode;
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
  var valid_568305 = path.getOrDefault("groupId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "groupId", valid_568305
  var valid_568306 = path.getOrDefault("hostName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "hostName", valid_568306
  var valid_568307 = path.getOrDefault("policyName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "policyName", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568308 = query.getOrDefault("api-version")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "api-version", valid_568308
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

proc call*(call_568310: Call_AndroidAddGroupForMAMPolicy_568302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add group to an AndroidMAMPolicy.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_AndroidAddGroupForMAMPolicy_568302; groupId: string;
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
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  var body_568314 = newJObject()
  add(path_568312, "groupId", newJString(groupId))
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "hostName", newJString(hostName))
  add(path_568312, "policyName", newJString(policyName))
  if parameters != nil:
    body_568314 = parameters
  result = call_568311.call(path_568312, query_568313, nil, nil, body_568314)

var androidAddGroupForMAMPolicy* = Call_AndroidAddGroupForMAMPolicy_568302(
    name: "androidAddGroupForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups/{groupId}",
    validator: validate_AndroidAddGroupForMAMPolicy_568303, base: "",
    url: url_AndroidAddGroupForMAMPolicy_568304, schemes: {Scheme.Https})
type
  Call_AndroidDeleteGroupForMAMPolicy_568315 = ref object of OpenApiRestCall_567641
proc url_AndroidDeleteGroupForMAMPolicy_568317(protocol: Scheme; host: string;
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

proc validate_AndroidDeleteGroupForMAMPolicy_568316(path: JsonNode;
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
  var valid_568318 = path.getOrDefault("groupId")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "groupId", valid_568318
  var valid_568319 = path.getOrDefault("hostName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "hostName", valid_568319
  var valid_568320 = path.getOrDefault("policyName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "policyName", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_AndroidDeleteGroupForMAMPolicy_568315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group for Android Policy
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_AndroidDeleteGroupForMAMPolicy_568315;
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
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(path_568324, "groupId", newJString(groupId))
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "hostName", newJString(hostName))
  add(path_568324, "policyName", newJString(policyName))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var androidDeleteGroupForMAMPolicy* = Call_AndroidDeleteGroupForMAMPolicy_568315(
    name: "androidDeleteGroupForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/androidPolicies/{policyName}/groups/{groupId}",
    validator: validate_AndroidDeleteGroupForMAMPolicy_568316, base: "",
    url: url_AndroidDeleteGroupForMAMPolicy_568317, schemes: {Scheme.Https})
type
  Call_GetApps_568326 = ref object of OpenApiRestCall_567641
proc url_GetApps_568328(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetApps_568327(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568329 = path.getOrDefault("hostName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "hostName", valid_568329
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
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  var valid_568331 = query.getOrDefault("$top")
  valid_568331 = validateParameter(valid_568331, JInt, required = false, default = nil)
  if valid_568331 != nil:
    section.add "$top", valid_568331
  var valid_568332 = query.getOrDefault("$select")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "$select", valid_568332
  var valid_568333 = query.getOrDefault("$filter")
  valid_568333 = validateParameter(valid_568333, JString, required = false,
                                 default = nil)
  if valid_568333 != nil:
    section.add "$filter", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_GetApps_568326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Manageable apps.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_GetApps_568326; apiVersion: string; hostName: string;
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
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(query_568337, "api-version", newJString(apiVersion))
  add(query_568337, "$top", newJInt(Top))
  add(query_568337, "$select", newJString(Select))
  add(path_568336, "hostName", newJString(hostName))
  add(query_568337, "$filter", newJString(Filter))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var getApps* = Call_GetApps_568326(name: "getApps", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/apps",
                                validator: validate_GetApps_568327, base: "",
                                url: url_GetApps_568328, schemes: {Scheme.Https})
type
  Call_GetMAMFlaggedUsers_568338 = ref object of OpenApiRestCall_567641
proc url_GetMAMFlaggedUsers_568340(protocol: Scheme; host: string; base: string;
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

proc validate_GetMAMFlaggedUsers_568339(path: JsonNode; query: JsonNode;
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
  var valid_568341 = path.getOrDefault("hostName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "hostName", valid_568341
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
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  var valid_568343 = query.getOrDefault("$top")
  valid_568343 = validateParameter(valid_568343, JInt, required = false, default = nil)
  if valid_568343 != nil:
    section.add "$top", valid_568343
  var valid_568344 = query.getOrDefault("$select")
  valid_568344 = validateParameter(valid_568344, JString, required = false,
                                 default = nil)
  if valid_568344 != nil:
    section.add "$select", valid_568344
  var valid_568345 = query.getOrDefault("$filter")
  valid_568345 = validateParameter(valid_568345, JString, required = false,
                                 default = nil)
  if valid_568345 != nil:
    section.add "$filter", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_GetMAMFlaggedUsers_568338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged user collection
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_GetMAMFlaggedUsers_568338; apiVersion: string;
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
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  add(query_568349, "api-version", newJString(apiVersion))
  add(query_568349, "$top", newJInt(Top))
  add(query_568349, "$select", newJString(Select))
  add(path_568348, "hostName", newJString(hostName))
  add(query_568349, "$filter", newJString(Filter))
  result = call_568347.call(path_568348, query_568349, nil, nil, nil)

var getMAMFlaggedUsers* = Call_GetMAMFlaggedUsers_568338(
    name: "getMAMFlaggedUsers", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers",
    validator: validate_GetMAMFlaggedUsers_568339, base: "",
    url: url_GetMAMFlaggedUsers_568340, schemes: {Scheme.Https})
type
  Call_GetMAMFlaggedUserByName_568350 = ref object of OpenApiRestCall_567641
proc url_GetMAMFlaggedUserByName_568352(protocol: Scheme; host: string; base: string;
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

proc validate_GetMAMFlaggedUserByName_568351(path: JsonNode; query: JsonNode;
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
  var valid_568353 = path.getOrDefault("hostName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "hostName", valid_568353
  var valid_568354 = path.getOrDefault("userName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "userName", valid_568354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568355 = query.getOrDefault("api-version")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "api-version", valid_568355
  var valid_568356 = query.getOrDefault("$select")
  valid_568356 = validateParameter(valid_568356, JString, required = false,
                                 default = nil)
  if valid_568356 != nil:
    section.add "$select", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_GetMAMFlaggedUserByName_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged user details
  ## 
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_GetMAMFlaggedUserByName_568350; apiVersion: string;
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
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(query_568360, "api-version", newJString(apiVersion))
  add(query_568360, "$select", newJString(Select))
  add(path_568359, "hostName", newJString(hostName))
  add(path_568359, "userName", newJString(userName))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var getMAMFlaggedUserByName* = Call_GetMAMFlaggedUserByName_568350(
    name: "getMAMFlaggedUserByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers/{userName}",
    validator: validate_GetMAMFlaggedUserByName_568351, base: "",
    url: url_GetMAMFlaggedUserByName_568352, schemes: {Scheme.Https})
type
  Call_GetMAMUserFlaggedEnrolledApps_568361 = ref object of OpenApiRestCall_567641
proc url_GetMAMUserFlaggedEnrolledApps_568363(protocol: Scheme; host: string;
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

proc validate_GetMAMUserFlaggedEnrolledApps_568362(path: JsonNode; query: JsonNode;
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
  var valid_568364 = path.getOrDefault("hostName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "hostName", valid_568364
  var valid_568365 = path.getOrDefault("userName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "userName", valid_568365
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
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  var valid_568367 = query.getOrDefault("$top")
  valid_568367 = validateParameter(valid_568367, JInt, required = false, default = nil)
  if valid_568367 != nil:
    section.add "$top", valid_568367
  var valid_568368 = query.getOrDefault("$select")
  valid_568368 = validateParameter(valid_568368, JString, required = false,
                                 default = nil)
  if valid_568368 != nil:
    section.add "$select", valid_568368
  var valid_568369 = query.getOrDefault("$filter")
  valid_568369 = validateParameter(valid_568369, JString, required = false,
                                 default = nil)
  if valid_568369 != nil:
    section.add "$filter", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_GetMAMUserFlaggedEnrolledApps_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune flagged enrolled app collection for the User
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_GetMAMUserFlaggedEnrolledApps_568361;
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
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(query_568373, "api-version", newJString(apiVersion))
  add(query_568373, "$top", newJInt(Top))
  add(query_568373, "$select", newJString(Select))
  add(path_568372, "hostName", newJString(hostName))
  add(path_568372, "userName", newJString(userName))
  add(query_568373, "$filter", newJString(Filter))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var getMAMUserFlaggedEnrolledApps* = Call_GetMAMUserFlaggedEnrolledApps_568361(
    name: "getMAMUserFlaggedEnrolledApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/flaggedUsers/{userName}/flaggedEnrolledApps",
    validator: validate_GetMAMUserFlaggedEnrolledApps_568362, base: "",
    url: url_GetMAMUserFlaggedEnrolledApps_568363, schemes: {Scheme.Https})
type
  Call_IosGetMAMPolicies_568374 = ref object of OpenApiRestCall_567641
proc url_IosGetMAMPolicies_568376(protocol: Scheme; host: string; base: string;
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

proc validate_IosGetMAMPolicies_568375(path: JsonNode; query: JsonNode;
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
  var valid_568377 = path.getOrDefault("hostName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "hostName", valid_568377
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
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  var valid_568379 = query.getOrDefault("$top")
  valid_568379 = validateParameter(valid_568379, JInt, required = false, default = nil)
  if valid_568379 != nil:
    section.add "$top", valid_568379
  var valid_568380 = query.getOrDefault("$select")
  valid_568380 = validateParameter(valid_568380, JString, required = false,
                                 default = nil)
  if valid_568380 != nil:
    section.add "$select", valid_568380
  var valid_568381 = query.getOrDefault("$filter")
  valid_568381 = validateParameter(valid_568381, JString, required = false,
                                 default = nil)
  if valid_568381 != nil:
    section.add "$filter", valid_568381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568382: Call_IosGetMAMPolicies_568374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune iOSPolicies.
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_IosGetMAMPolicies_568374; apiVersion: string;
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
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  add(query_568385, "api-version", newJString(apiVersion))
  add(query_568385, "$top", newJInt(Top))
  add(query_568385, "$select", newJString(Select))
  add(path_568384, "hostName", newJString(hostName))
  add(query_568385, "$filter", newJString(Filter))
  result = call_568383.call(path_568384, query_568385, nil, nil, nil)

var iosGetMAMPolicies* = Call_IosGetMAMPolicies_568374(name: "iosGetMAMPolicies",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies",
    validator: validate_IosGetMAMPolicies_568375, base: "",
    url: url_IosGetMAMPolicies_568376, schemes: {Scheme.Https})
type
  Call_IosCreateOrUpdateMAMPolicy_568397 = ref object of OpenApiRestCall_567641
proc url_IosCreateOrUpdateMAMPolicy_568399(protocol: Scheme; host: string;
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

proc validate_IosCreateOrUpdateMAMPolicy_568398(path: JsonNode; query: JsonNode;
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
  var valid_568400 = path.getOrDefault("hostName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "hostName", valid_568400
  var valid_568401 = path.getOrDefault("policyName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "policyName", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
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

proc call*(call_568404: Call_IosCreateOrUpdateMAMPolicy_568397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates iOSMAMPolicy.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_IosCreateOrUpdateMAMPolicy_568397; apiVersion: string;
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
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  var body_568408 = newJObject()
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "hostName", newJString(hostName))
  add(path_568406, "policyName", newJString(policyName))
  if parameters != nil:
    body_568408 = parameters
  result = call_568405.call(path_568406, query_568407, nil, nil, body_568408)

var iosCreateOrUpdateMAMPolicy* = Call_IosCreateOrUpdateMAMPolicy_568397(
    name: "iosCreateOrUpdateMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosCreateOrUpdateMAMPolicy_568398, base: "",
    url: url_IosCreateOrUpdateMAMPolicy_568399, schemes: {Scheme.Https})
type
  Call_IosGetMAMPolicyByName_568386 = ref object of OpenApiRestCall_567641
proc url_IosGetMAMPolicyByName_568388(protocol: Scheme; host: string; base: string;
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

proc validate_IosGetMAMPolicyByName_568387(path: JsonNode; query: JsonNode;
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
  var valid_568389 = path.getOrDefault("hostName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "hostName", valid_568389
  var valid_568390 = path.getOrDefault("policyName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "policyName", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  var valid_568392 = query.getOrDefault("$select")
  valid_568392 = validateParameter(valid_568392, JString, required = false,
                                 default = nil)
  if valid_568392 != nil:
    section.add "$select", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_IosGetMAMPolicyByName_568386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune iOS policies.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_IosGetMAMPolicyByName_568386; apiVersion: string;
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
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(query_568396, "api-version", newJString(apiVersion))
  add(query_568396, "$select", newJString(Select))
  add(path_568395, "hostName", newJString(hostName))
  add(path_568395, "policyName", newJString(policyName))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var iosGetMAMPolicyByName* = Call_IosGetMAMPolicyByName_568386(
    name: "iosGetMAMPolicyByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosGetMAMPolicyByName_568387, base: "",
    url: url_IosGetMAMPolicyByName_568388, schemes: {Scheme.Https})
type
  Call_IosPatchMAMPolicy_568419 = ref object of OpenApiRestCall_567641
proc url_IosPatchMAMPolicy_568421(protocol: Scheme; host: string; base: string;
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

proc validate_IosPatchMAMPolicy_568420(path: JsonNode; query: JsonNode;
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
  var valid_568422 = path.getOrDefault("hostName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "hostName", valid_568422
  var valid_568423 = path.getOrDefault("policyName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "policyName", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
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

proc call*(call_568426: Call_IosPatchMAMPolicy_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  patch an iOSMAMPolicy.
  ## 
  let valid = call_568426.validator(path, query, header, formData, body)
  let scheme = call_568426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568426.url(scheme.get, call_568426.host, call_568426.base,
                         call_568426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568426, url, valid)

proc call*(call_568427: Call_IosPatchMAMPolicy_568419; apiVersion: string;
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
  var path_568428 = newJObject()
  var query_568429 = newJObject()
  var body_568430 = newJObject()
  add(query_568429, "api-version", newJString(apiVersion))
  add(path_568428, "hostName", newJString(hostName))
  add(path_568428, "policyName", newJString(policyName))
  if parameters != nil:
    body_568430 = parameters
  result = call_568427.call(path_568428, query_568429, nil, nil, body_568430)

var iosPatchMAMPolicy* = Call_IosPatchMAMPolicy_568419(name: "iosPatchMAMPolicy",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosPatchMAMPolicy_568420, base: "",
    url: url_IosPatchMAMPolicy_568421, schemes: {Scheme.Https})
type
  Call_IosDeleteMAMPolicy_568409 = ref object of OpenApiRestCall_567641
proc url_IosDeleteMAMPolicy_568411(protocol: Scheme; host: string; base: string;
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

proc validate_IosDeleteMAMPolicy_568410(path: JsonNode; query: JsonNode;
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
  var valid_568412 = path.getOrDefault("hostName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "hostName", valid_568412
  var valid_568413 = path.getOrDefault("policyName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "policyName", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_IosDeleteMAMPolicy_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Ios Policy
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_IosDeleteMAMPolicy_568409; apiVersion: string;
          hostName: string; policyName: string): Recallable =
  ## iosDeleteMAMPolicy
  ## Delete Ios Policy
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : Unique name for the policy
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "hostName", newJString(hostName))
  add(path_568417, "policyName", newJString(policyName))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var iosDeleteMAMPolicy* = Call_IosDeleteMAMPolicy_568409(
    name: "iosDeleteMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}",
    validator: validate_IosDeleteMAMPolicy_568410, base: "",
    url: url_IosDeleteMAMPolicy_568411, schemes: {Scheme.Https})
type
  Call_IosGetAppForMAMPolicy_568431 = ref object of OpenApiRestCall_567641
proc url_IosGetAppForMAMPolicy_568433(protocol: Scheme; host: string; base: string;
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

proc validate_IosGetAppForMAMPolicy_568432(path: JsonNode; query: JsonNode;
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
  var valid_568434 = path.getOrDefault("hostName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "hostName", valid_568434
  var valid_568435 = path.getOrDefault("policyName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "policyName", valid_568435
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
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "api-version", valid_568436
  var valid_568437 = query.getOrDefault("$top")
  valid_568437 = validateParameter(valid_568437, JInt, required = false, default = nil)
  if valid_568437 != nil:
    section.add "$top", valid_568437
  var valid_568438 = query.getOrDefault("$select")
  valid_568438 = validateParameter(valid_568438, JString, required = false,
                                 default = nil)
  if valid_568438 != nil:
    section.add "$select", valid_568438
  var valid_568439 = query.getOrDefault("$filter")
  valid_568439 = validateParameter(valid_568439, JString, required = false,
                                 default = nil)
  if valid_568439 != nil:
    section.add "$filter", valid_568439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568440: Call_IosGetAppForMAMPolicy_568431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get apps for an iOSMAMPolicy.
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_IosGetAppForMAMPolicy_568431; apiVersion: string;
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
  var path_568442 = newJObject()
  var query_568443 = newJObject()
  add(query_568443, "api-version", newJString(apiVersion))
  add(query_568443, "$top", newJInt(Top))
  add(query_568443, "$select", newJString(Select))
  add(path_568442, "hostName", newJString(hostName))
  add(path_568442, "policyName", newJString(policyName))
  add(query_568443, "$filter", newJString(Filter))
  result = call_568441.call(path_568442, query_568443, nil, nil, nil)

var iosGetAppForMAMPolicy* = Call_IosGetAppForMAMPolicy_568431(
    name: "iosGetAppForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps",
    validator: validate_IosGetAppForMAMPolicy_568432, base: "",
    url: url_IosGetAppForMAMPolicy_568433, schemes: {Scheme.Https})
type
  Call_IosAddAppForMAMPolicy_568444 = ref object of OpenApiRestCall_567641
proc url_IosAddAppForMAMPolicy_568446(protocol: Scheme; host: string; base: string;
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

proc validate_IosAddAppForMAMPolicy_568445(path: JsonNode; query: JsonNode;
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
  var valid_568447 = path.getOrDefault("appName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "appName", valid_568447
  var valid_568448 = path.getOrDefault("hostName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "hostName", valid_568448
  var valid_568449 = path.getOrDefault("policyName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "policyName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
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

proc call*(call_568452: Call_IosAddAppForMAMPolicy_568444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add app to an iOSMAMPolicy.
  ## 
  let valid = call_568452.validator(path, query, header, formData, body)
  let scheme = call_568452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568452.url(scheme.get, call_568452.host, call_568452.base,
                         call_568452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568452, url, valid)

proc call*(call_568453: Call_IosAddAppForMAMPolicy_568444; apiVersion: string;
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
  var path_568454 = newJObject()
  var query_568455 = newJObject()
  var body_568456 = newJObject()
  add(query_568455, "api-version", newJString(apiVersion))
  add(path_568454, "appName", newJString(appName))
  add(path_568454, "hostName", newJString(hostName))
  add(path_568454, "policyName", newJString(policyName))
  if parameters != nil:
    body_568456 = parameters
  result = call_568453.call(path_568454, query_568455, nil, nil, body_568456)

var iosAddAppForMAMPolicy* = Call_IosAddAppForMAMPolicy_568444(
    name: "iosAddAppForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps/{appName}",
    validator: validate_IosAddAppForMAMPolicy_568445, base: "",
    url: url_IosAddAppForMAMPolicy_568446, schemes: {Scheme.Https})
type
  Call_IosDeleteAppForMAMPolicy_568457 = ref object of OpenApiRestCall_567641
proc url_IosDeleteAppForMAMPolicy_568459(protocol: Scheme; host: string;
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

proc validate_IosDeleteAppForMAMPolicy_568458(path: JsonNode; query: JsonNode;
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
  var valid_568460 = path.getOrDefault("appName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "appName", valid_568460
  var valid_568461 = path.getOrDefault("hostName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "hostName", valid_568461
  var valid_568462 = path.getOrDefault("policyName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "policyName", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_IosDeleteAppForMAMPolicy_568457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete App for Ios Policy
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_IosDeleteAppForMAMPolicy_568457; apiVersion: string;
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
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "appName", newJString(appName))
  add(path_568466, "hostName", newJString(hostName))
  add(path_568466, "policyName", newJString(policyName))
  result = call_568465.call(path_568466, query_568467, nil, nil, nil)

var iosDeleteAppForMAMPolicy* = Call_IosDeleteAppForMAMPolicy_568457(
    name: "iosDeleteAppForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/apps/{appName}",
    validator: validate_IosDeleteAppForMAMPolicy_568458, base: "",
    url: url_IosDeleteAppForMAMPolicy_568459, schemes: {Scheme.Https})
type
  Call_IosGetGroupsForMAMPolicy_568468 = ref object of OpenApiRestCall_567641
proc url_IosGetGroupsForMAMPolicy_568470(protocol: Scheme; host: string;
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

proc validate_IosGetGroupsForMAMPolicy_568469(path: JsonNode; query: JsonNode;
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
  var valid_568471 = path.getOrDefault("hostName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "hostName", valid_568471
  var valid_568472 = path.getOrDefault("policyName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "policyName", valid_568472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568473 = query.getOrDefault("api-version")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "api-version", valid_568473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_IosGetGroupsForMAMPolicy_568468; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns groups for a given iOSMAMPolicy.
  ## 
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_IosGetGroupsForMAMPolicy_568468; apiVersion: string;
          hostName: string; policyName: string): Recallable =
  ## iosGetGroupsForMAMPolicy
  ## Returns groups for a given iOSMAMPolicy.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  ##   policyName: string (required)
  ##             : policy name for the tenant
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "hostName", newJString(hostName))
  add(path_568476, "policyName", newJString(policyName))
  result = call_568475.call(path_568476, query_568477, nil, nil, nil)

var iosGetGroupsForMAMPolicy* = Call_IosGetGroupsForMAMPolicy_568468(
    name: "iosGetGroupsForMAMPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups",
    validator: validate_IosGetGroupsForMAMPolicy_568469, base: "",
    url: url_IosGetGroupsForMAMPolicy_568470, schemes: {Scheme.Https})
type
  Call_IosAddGroupForMAMPolicy_568478 = ref object of OpenApiRestCall_567641
proc url_IosAddGroupForMAMPolicy_568480(protocol: Scheme; host: string; base: string;
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

proc validate_IosAddGroupForMAMPolicy_568479(path: JsonNode; query: JsonNode;
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
  var valid_568481 = path.getOrDefault("groupId")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "groupId", valid_568481
  var valid_568482 = path.getOrDefault("hostName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "hostName", valid_568482
  var valid_568483 = path.getOrDefault("policyName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "policyName", valid_568483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568484 = query.getOrDefault("api-version")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "api-version", valid_568484
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

proc call*(call_568486: Call_IosAddGroupForMAMPolicy_568478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add group to an iOSMAMPolicy.
  ## 
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_IosAddGroupForMAMPolicy_568478; groupId: string;
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
  var path_568488 = newJObject()
  var query_568489 = newJObject()
  var body_568490 = newJObject()
  add(path_568488, "groupId", newJString(groupId))
  add(query_568489, "api-version", newJString(apiVersion))
  add(path_568488, "hostName", newJString(hostName))
  add(path_568488, "policyName", newJString(policyName))
  if parameters != nil:
    body_568490 = parameters
  result = call_568487.call(path_568488, query_568489, nil, nil, body_568490)

var iosAddGroupForMAMPolicy* = Call_IosAddGroupForMAMPolicy_568478(
    name: "iosAddGroupForMAMPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups/{groupId}",
    validator: validate_IosAddGroupForMAMPolicy_568479, base: "",
    url: url_IosAddGroupForMAMPolicy_568480, schemes: {Scheme.Https})
type
  Call_IosDeleteGroupForMAMPolicy_568491 = ref object of OpenApiRestCall_567641
proc url_IosDeleteGroupForMAMPolicy_568493(protocol: Scheme; host: string;
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

proc validate_IosDeleteGroupForMAMPolicy_568492(path: JsonNode; query: JsonNode;
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
  var valid_568494 = path.getOrDefault("groupId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "groupId", valid_568494
  var valid_568495 = path.getOrDefault("hostName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "hostName", valid_568495
  var valid_568496 = path.getOrDefault("policyName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "policyName", valid_568496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568497 = query.getOrDefault("api-version")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "api-version", valid_568497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568498: Call_IosDeleteGroupForMAMPolicy_568491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group for iOS Policy
  ## 
  let valid = call_568498.validator(path, query, header, formData, body)
  let scheme = call_568498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568498.url(scheme.get, call_568498.host, call_568498.base,
                         call_568498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568498, url, valid)

proc call*(call_568499: Call_IosDeleteGroupForMAMPolicy_568491; groupId: string;
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
  var path_568500 = newJObject()
  var query_568501 = newJObject()
  add(path_568500, "groupId", newJString(groupId))
  add(query_568501, "api-version", newJString(apiVersion))
  add(path_568500, "hostName", newJString(hostName))
  add(path_568500, "policyName", newJString(policyName))
  result = call_568499.call(path_568500, query_568501, nil, nil, nil)

var iosDeleteGroupForMAMPolicy* = Call_IosDeleteGroupForMAMPolicy_568491(
    name: "iosDeleteGroupForMAMPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/iosPolicies/{policyName}/groups/{groupId}",
    validator: validate_IosDeleteGroupForMAMPolicy_568492, base: "",
    url: url_IosDeleteGroupForMAMPolicy_568493, schemes: {Scheme.Https})
type
  Call_GetOperationResults_568502 = ref object of OpenApiRestCall_567641
proc url_GetOperationResults_568504(protocol: Scheme; host: string; base: string;
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

proc validate_GetOperationResults_568503(path: JsonNode; query: JsonNode;
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
  var valid_568505 = path.getOrDefault("hostName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "hostName", valid_568505
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
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  var valid_568507 = query.getOrDefault("$top")
  valid_568507 = validateParameter(valid_568507, JInt, required = false, default = nil)
  if valid_568507 != nil:
    section.add "$top", valid_568507
  var valid_568508 = query.getOrDefault("$select")
  valid_568508 = validateParameter(valid_568508, JString, required = false,
                                 default = nil)
  if valid_568508 != nil:
    section.add "$select", valid_568508
  var valid_568509 = query.getOrDefault("$filter")
  valid_568509 = validateParameter(valid_568509, JString, required = false,
                                 default = nil)
  if valid_568509 != nil:
    section.add "$filter", valid_568509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568510: Call_GetOperationResults_568502; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns operationResults.
  ## 
  let valid = call_568510.validator(path, query, header, formData, body)
  let scheme = call_568510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568510.url(scheme.get, call_568510.host, call_568510.base,
                         call_568510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568510, url, valid)

proc call*(call_568511: Call_GetOperationResults_568502; apiVersion: string;
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
  var path_568512 = newJObject()
  var query_568513 = newJObject()
  add(query_568513, "api-version", newJString(apiVersion))
  add(query_568513, "$top", newJInt(Top))
  add(query_568513, "$select", newJString(Select))
  add(path_568512, "hostName", newJString(hostName))
  add(query_568513, "$filter", newJString(Filter))
  result = call_568511.call(path_568512, query_568513, nil, nil, nil)

var getOperationResults* = Call_GetOperationResults_568502(
    name: "getOperationResults", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/operationResults",
    validator: validate_GetOperationResults_568503, base: "",
    url: url_GetOperationResults_568504, schemes: {Scheme.Https})
type
  Call_GetMAMStatuses_568514 = ref object of OpenApiRestCall_567641
proc url_GetMAMStatuses_568516(protocol: Scheme; host: string; base: string;
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

proc validate_GetMAMStatuses_568515(path: JsonNode; query: JsonNode;
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
  var valid_568517 = path.getOrDefault("hostName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "hostName", valid_568517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568518 = query.getOrDefault("api-version")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "api-version", valid_568518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568519: Call_GetMAMStatuses_568514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Intune Tenant level statuses.
  ## 
  let valid = call_568519.validator(path, query, header, formData, body)
  let scheme = call_568519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568519.url(scheme.get, call_568519.host, call_568519.base,
                         call_568519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568519, url, valid)

proc call*(call_568520: Call_GetMAMStatuses_568514; apiVersion: string;
          hostName: string): Recallable =
  ## getMAMStatuses
  ## Returns Intune Tenant level statuses.
  ##   apiVersion: string (required)
  ##             : Service Api Version.
  ##   hostName: string (required)
  ##           : Location hostName for the tenant
  var path_568521 = newJObject()
  var query_568522 = newJObject()
  add(query_568522, "api-version", newJString(apiVersion))
  add(path_568521, "hostName", newJString(hostName))
  result = call_568520.call(path_568521, query_568522, nil, nil, nil)

var getMAMStatuses* = Call_GetMAMStatuses_568514(name: "getMAMStatuses",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Intune/locations/{hostName}/statuses/default",
    validator: validate_GetMAMStatuses_568515, base: "", url: url_GetMAMStatuses_568516,
    schemes: {Scheme.Https})
type
  Call_GetMAMUserDevices_568523 = ref object of OpenApiRestCall_567641
proc url_GetMAMUserDevices_568525(protocol: Scheme; host: string; base: string;
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

proc validate_GetMAMUserDevices_568524(path: JsonNode; query: JsonNode;
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
  var valid_568526 = path.getOrDefault("hostName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "hostName", valid_568526
  var valid_568527 = path.getOrDefault("userName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "userName", valid_568527
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
  var valid_568528 = query.getOrDefault("api-version")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "api-version", valid_568528
  var valid_568529 = query.getOrDefault("$top")
  valid_568529 = validateParameter(valid_568529, JInt, required = false, default = nil)
  if valid_568529 != nil:
    section.add "$top", valid_568529
  var valid_568530 = query.getOrDefault("$select")
  valid_568530 = validateParameter(valid_568530, JString, required = false,
                                 default = nil)
  if valid_568530 != nil:
    section.add "$select", valid_568530
  var valid_568531 = query.getOrDefault("$filter")
  valid_568531 = validateParameter(valid_568531, JString, required = false,
                                 default = nil)
  if valid_568531 != nil:
    section.add "$filter", valid_568531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568532: Call_GetMAMUserDevices_568523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get devices for a user.
  ## 
  let valid = call_568532.validator(path, query, header, formData, body)
  let scheme = call_568532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568532.url(scheme.get, call_568532.host, call_568532.base,
                         call_568532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568532, url, valid)

proc call*(call_568533: Call_GetMAMUserDevices_568523; apiVersion: string;
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
  var path_568534 = newJObject()
  var query_568535 = newJObject()
  add(query_568535, "api-version", newJString(apiVersion))
  add(query_568535, "$top", newJInt(Top))
  add(query_568535, "$select", newJString(Select))
  add(path_568534, "hostName", newJString(hostName))
  add(path_568534, "userName", newJString(userName))
  add(query_568535, "$filter", newJString(Filter))
  result = call_568533.call(path_568534, query_568535, nil, nil, nil)

var getMAMUserDevices* = Call_GetMAMUserDevices_568523(name: "getMAMUserDevices",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices",
    validator: validate_GetMAMUserDevices_568524, base: "",
    url: url_GetMAMUserDevices_568525, schemes: {Scheme.Https})
type
  Call_GetMAMUserDeviceByDeviceName_568536 = ref object of OpenApiRestCall_567641
proc url_GetMAMUserDeviceByDeviceName_568538(protocol: Scheme; host: string;
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

proc validate_GetMAMUserDeviceByDeviceName_568537(path: JsonNode; query: JsonNode;
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
  var valid_568539 = path.getOrDefault("hostName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "hostName", valid_568539
  var valid_568540 = path.getOrDefault("userName")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "userName", valid_568540
  var valid_568541 = path.getOrDefault("deviceName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "deviceName", valid_568541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  ##   $select: JString
  ##          : select specific fields in entity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568542 = query.getOrDefault("api-version")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "api-version", valid_568542
  var valid_568543 = query.getOrDefault("$select")
  valid_568543 = validateParameter(valid_568543, JString, required = false,
                                 default = nil)
  if valid_568543 != nil:
    section.add "$select", valid_568543
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568544: Call_GetMAMUserDeviceByDeviceName_568536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a unique device for a user.
  ## 
  let valid = call_568544.validator(path, query, header, formData, body)
  let scheme = call_568544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568544.url(scheme.get, call_568544.host, call_568544.base,
                         call_568544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568544, url, valid)

proc call*(call_568545: Call_GetMAMUserDeviceByDeviceName_568536;
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
  var path_568546 = newJObject()
  var query_568547 = newJObject()
  add(query_568547, "api-version", newJString(apiVersion))
  add(query_568547, "$select", newJString(Select))
  add(path_568546, "hostName", newJString(hostName))
  add(path_568546, "userName", newJString(userName))
  add(path_568546, "deviceName", newJString(deviceName))
  result = call_568545.call(path_568546, query_568547, nil, nil, nil)

var getMAMUserDeviceByDeviceName* = Call_GetMAMUserDeviceByDeviceName_568536(
    name: "getMAMUserDeviceByDeviceName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices/{deviceName}",
    validator: validate_GetMAMUserDeviceByDeviceName_568537, base: "",
    url: url_GetMAMUserDeviceByDeviceName_568538, schemes: {Scheme.Https})
type
  Call_WipeMAMUserDevice_568548 = ref object of OpenApiRestCall_567641
proc url_WipeMAMUserDevice_568550(protocol: Scheme; host: string; base: string;
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

proc validate_WipeMAMUserDevice_568549(path: JsonNode; query: JsonNode;
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
  var valid_568551 = path.getOrDefault("hostName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "hostName", valid_568551
  var valid_568552 = path.getOrDefault("userName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "userName", valid_568552
  var valid_568553 = path.getOrDefault("deviceName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "deviceName", valid_568553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Service Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568554 = query.getOrDefault("api-version")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "api-version", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_WipeMAMUserDevice_568548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Wipe a device for a user.
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_WipeMAMUserDevice_568548; apiVersion: string;
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
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "hostName", newJString(hostName))
  add(path_568557, "userName", newJString(userName))
  add(path_568557, "deviceName", newJString(deviceName))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var wipeMAMUserDevice* = Call_WipeMAMUserDevice_568548(name: "wipeMAMUserDevice",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Intune/locations/{hostName}/users/{userName}/devices/{deviceName}/wipe",
    validator: validate_WipeMAMUserDevice_568549, base: "",
    url: url_WipeMAMUserDevice_568550, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
