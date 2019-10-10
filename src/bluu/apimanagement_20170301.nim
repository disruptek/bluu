
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on entities like API, Product, and Subscription associated with your Azure API Management deployment.
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyList_573880 = ref object of OpenApiRestCall_573658
proc url_PolicyList_573882(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicyList_573881(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Global Policy definitions of the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   scope: JString
  ##        : Policy scope.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574041 = query.getOrDefault("api-version")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "api-version", valid_574041
  var valid_574055 = query.getOrDefault("scope")
  valid_574055 = validateParameter(valid_574055, JString, required = false,
                                 default = newJString("Tenant"))
  if valid_574055 != nil:
    section.add "scope", valid_574055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574078: Call_PolicyList_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Global Policy definitions of the Api Management service.
  ## 
  let valid = call_574078.validator(path, query, header, formData, body)
  let scheme = call_574078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574078.url(scheme.get, call_574078.host, call_574078.base,
                         call_574078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574078, url, valid)

proc call*(call_574149: Call_PolicyList_573880; apiVersion: string;
          scope: string = "Tenant"): Recallable =
  ## policyList
  ## Lists all the Global Policy definitions of the Api Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   scope: string
  ##        : Policy scope.
  var query_574150 = newJObject()
  add(query_574150, "api-version", newJString(apiVersion))
  add(query_574150, "scope", newJString(scope))
  result = call_574149.call(nil, query_574150, nil, nil, nil)

var policyList* = Call_PolicyList_573880(name: "policyList",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/policies",
                                      validator: validate_PolicyList_573881,
                                      base: "", url: url_PolicyList_573882,
                                      schemes: {Scheme.Https})
type
  Call_PolicyCreateOrUpdate_574213 = ref object of OpenApiRestCall_573658
proc url_PolicyCreateOrUpdate_574215(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyCreateOrUpdate_574214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the global policy configuration of the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyId` field"
  var valid_574233 = path.getOrDefault("policyId")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = newJString("policy"))
  if valid_574233 != nil:
    section.add "policyId", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574234 = query.getOrDefault("api-version")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "api-version", valid_574234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574236: Call_PolicyCreateOrUpdate_574213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the global policy configuration of the Api Management service.
  ## 
  let valid = call_574236.validator(path, query, header, formData, body)
  let scheme = call_574236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574236.url(scheme.get, call_574236.host, call_574236.base,
                         call_574236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574236, url, valid)

proc call*(call_574237: Call_PolicyCreateOrUpdate_574213; apiVersion: string;
          parameters: JsonNode; policyId: string = "policy"): Recallable =
  ## policyCreateOrUpdate
  ## Creates or updates the global policy configuration of the Api Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  var path_574238 = newJObject()
  var query_574239 = newJObject()
  var body_574240 = newJObject()
  add(query_574239, "api-version", newJString(apiVersion))
  add(path_574238, "policyId", newJString(policyId))
  if parameters != nil:
    body_574240 = parameters
  result = call_574237.call(path_574238, query_574239, nil, nil, body_574240)

var policyCreateOrUpdate* = Call_PolicyCreateOrUpdate_574213(
    name: "policyCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/policies/{policyId}", validator: validate_PolicyCreateOrUpdate_574214,
    base: "", url: url_PolicyCreateOrUpdate_574215, schemes: {Scheme.Https})
type
  Call_PolicyGet_574190 = ref object of OpenApiRestCall_573658
proc url_PolicyGet_574192(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyGet_574191(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the Global policy definition of the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyId` field"
  var valid_574207 = path.getOrDefault("policyId")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = newJString("policy"))
  if valid_574207 != nil:
    section.add "policyId", valid_574207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574208 = query.getOrDefault("api-version")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "api-version", valid_574208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574209: Call_PolicyGet_574190; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Global policy definition of the Api Management service.
  ## 
  let valid = call_574209.validator(path, query, header, formData, body)
  let scheme = call_574209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574209.url(scheme.get, call_574209.host, call_574209.base,
                         call_574209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574209, url, valid)

proc call*(call_574210: Call_PolicyGet_574190; apiVersion: string;
          policyId: string = "policy"): Recallable =
  ## policyGet
  ## Get the Global policy definition of the Api Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_574211 = newJObject()
  var query_574212 = newJObject()
  add(query_574212, "api-version", newJString(apiVersion))
  add(path_574211, "policyId", newJString(policyId))
  result = call_574210.call(path_574211, query_574212, nil, nil, nil)

var policyGet* = Call_PolicyGet_574190(name: "policyGet", meth: HttpMethod.HttpGet,
                                    host: "azure.local",
                                    route: "/policies/{policyId}",
                                    validator: validate_PolicyGet_574191,
                                    base: "", url: url_PolicyGet_574192,
                                    schemes: {Scheme.Https})
type
  Call_PolicyDelete_574241 = ref object of OpenApiRestCall_573658
proc url_PolicyDelete_574243(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDelete_574242(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the global policy configuration of the Api Management Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyId` field"
  var valid_574244 = path.getOrDefault("policyId")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = newJString("policy"))
  if valid_574244 != nil:
    section.add "policyId", valid_574244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574245 = query.getOrDefault("api-version")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "api-version", valid_574245
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the policy to be deleted. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574246 = header.getOrDefault("If-Match")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "If-Match", valid_574246
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574247: Call_PolicyDelete_574241; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the global policy configuration of the Api Management Service.
  ## 
  let valid = call_574247.validator(path, query, header, formData, body)
  let scheme = call_574247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574247.url(scheme.get, call_574247.host, call_574247.base,
                         call_574247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574247, url, valid)

proc call*(call_574248: Call_PolicyDelete_574241; apiVersion: string;
          policyId: string = "policy"): Recallable =
  ## policyDelete
  ## Deletes the global policy configuration of the Api Management Service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_574249 = newJObject()
  var query_574250 = newJObject()
  add(query_574250, "api-version", newJString(apiVersion))
  add(path_574249, "policyId", newJString(policyId))
  result = call_574248.call(path_574249, query_574250, nil, nil, nil)

var policyDelete* = Call_PolicyDelete_574241(name: "policyDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/policies/{policyId}",
    validator: validate_PolicyDelete_574242, base: "", url: url_PolicyDelete_574243,
    schemes: {Scheme.Https})
type
  Call_PolicySnippetsList_574251 = ref object of OpenApiRestCall_573658
proc url_PolicySnippetsList_574253(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicySnippetsList_574252(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all policy snippets.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   scope: JString
  ##        : Policy scope.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574254 = query.getOrDefault("api-version")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "api-version", valid_574254
  var valid_574255 = query.getOrDefault("scope")
  valid_574255 = validateParameter(valid_574255, JString, required = false,
                                 default = newJString("Tenant"))
  if valid_574255 != nil:
    section.add "scope", valid_574255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574256: Call_PolicySnippetsList_574251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all policy snippets.
  ## 
  let valid = call_574256.validator(path, query, header, formData, body)
  let scheme = call_574256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574256.url(scheme.get, call_574256.host, call_574256.base,
                         call_574256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574256, url, valid)

proc call*(call_574257: Call_PolicySnippetsList_574251; apiVersion: string;
          scope: string = "Tenant"): Recallable =
  ## policySnippetsList
  ## Lists all policy snippets.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   scope: string
  ##        : Policy scope.
  var query_574258 = newJObject()
  add(query_574258, "api-version", newJString(apiVersion))
  add(query_574258, "scope", newJString(scope))
  result = call_574257.call(nil, query_574258, nil, nil, nil)

var policySnippetsList* = Call_PolicySnippetsList_574251(
    name: "policySnippetsList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/policySnippets", validator: validate_PolicySnippetsList_574252,
    base: "", url: url_PolicySnippetsList_574253, schemes: {Scheme.Https})
type
  Call_RegionsList_574259 = ref object of OpenApiRestCall_573658
proc url_RegionsList_574261(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RegionsList_574260(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all azure regions in which the service exists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574262 = query.getOrDefault("api-version")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "api-version", valid_574262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574263: Call_RegionsList_574259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all azure regions in which the service exists.
  ## 
  let valid = call_574263.validator(path, query, header, formData, body)
  let scheme = call_574263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574263.url(scheme.get, call_574263.host, call_574263.base,
                         call_574263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574263, url, valid)

proc call*(call_574264: Call_RegionsList_574259; apiVersion: string): Recallable =
  ## regionsList
  ## Lists all azure regions in which the service exists.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_574265 = newJObject()
  add(query_574265, "api-version", newJString(apiVersion))
  result = call_574264.call(nil, query_574265, nil, nil, nil)

var regionsList* = Call_RegionsList_574259(name: "regionsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/regions",
                                        validator: validate_RegionsList_574260,
                                        base: "", url: url_RegionsList_574261,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
