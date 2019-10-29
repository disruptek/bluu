
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyList_563778 = ref object of OpenApiRestCall_563556
proc url_PolicyList_563780(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicyList_563779(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Global Policy definitions of the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   scope: JString
  ##        : Policy scope.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  var valid_563954 = query.getOrDefault("scope")
  valid_563954 = validateParameter(valid_563954, JString, required = false,
                                 default = newJString("Tenant"))
  if valid_563954 != nil:
    section.add "scope", valid_563954
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563955 = query.getOrDefault("api-version")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "api-version", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_PolicyList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Global Policy definitions of the Api Management service.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_PolicyList_563778; apiVersion: string;
          scope: string = "Tenant"): Recallable =
  ## policyList
  ## Lists all the Global Policy definitions of the Api Management service.
  ##   scope: string
  ##        : Policy scope.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_564050 = newJObject()
  add(query_564050, "scope", newJString(scope))
  add(query_564050, "api-version", newJString(apiVersion))
  result = call_564049.call(nil, query_564050, nil, nil, nil)

var policyList* = Call_PolicyList_563778(name: "policyList",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/policies",
                                      validator: validate_PolicyList_563779,
                                      base: "", url: url_PolicyList_563780,
                                      schemes: {Scheme.Https})
type
  Call_PolicyCreateOrUpdate_564113 = ref object of OpenApiRestCall_563556
proc url_PolicyCreateOrUpdate_564115(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyCreateOrUpdate_564114(path: JsonNode; query: JsonNode;
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
  var valid_564133 = path.getOrDefault("policyId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = newJString("policy"))
  if valid_564133 != nil:
    section.add "policyId", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
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

proc call*(call_564136: Call_PolicyCreateOrUpdate_564113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the global policy configuration of the Api Management service.
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_PolicyCreateOrUpdate_564113; apiVersion: string;
          parameters: JsonNode; policyId: string = "policy"): Recallable =
  ## policyCreateOrUpdate
  ## Creates or updates the global policy configuration of the Api Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  var body_564140 = newJObject()
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "policyId", newJString(policyId))
  if parameters != nil:
    body_564140 = parameters
  result = call_564137.call(path_564138, query_564139, nil, nil, body_564140)

var policyCreateOrUpdate* = Call_PolicyCreateOrUpdate_564113(
    name: "policyCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/policies/{policyId}", validator: validate_PolicyCreateOrUpdate_564114,
    base: "", url: url_PolicyCreateOrUpdate_564115, schemes: {Scheme.Https})
type
  Call_PolicyGet_564090 = ref object of OpenApiRestCall_563556
proc url_PolicyGet_564092(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PolicyGet_564091(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564107 = path.getOrDefault("policyId")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = newJString("policy"))
  if valid_564107 != nil:
    section.add "policyId", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_PolicyGet_564090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Global policy definition of the Api Management service.
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_PolicyGet_564090; apiVersion: string;
          policyId: string = "policy"): Recallable =
  ## policyGet
  ## Get the Global policy definition of the Api Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "api-version", newJString(apiVersion))
  add(path_564111, "policyId", newJString(policyId))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var policyGet* = Call_PolicyGet_564090(name: "policyGet", meth: HttpMethod.HttpGet,
                                    host: "azure.local",
                                    route: "/policies/{policyId}",
                                    validator: validate_PolicyGet_564091,
                                    base: "", url: url_PolicyGet_564092,
                                    schemes: {Scheme.Https})
type
  Call_PolicyDelete_564141 = ref object of OpenApiRestCall_563556
proc url_PolicyDelete_564143(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDelete_564142(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564144 = path.getOrDefault("policyId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = newJString("policy"))
  if valid_564144 != nil:
    section.add "policyId", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the policy to be deleted. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564146 = header.getOrDefault("If-Match")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "If-Match", valid_564146
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_PolicyDelete_564141; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the global policy configuration of the Api Management Service.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_PolicyDelete_564141; apiVersion: string;
          policyId: string = "policy"): Recallable =
  ## policyDelete
  ## Deletes the global policy configuration of the Api Management Service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "policyId", newJString(policyId))
  result = call_564148.call(path_564149, query_564150, nil, nil, nil)

var policyDelete* = Call_PolicyDelete_564141(name: "policyDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/policies/{policyId}",
    validator: validate_PolicyDelete_564142, base: "", url: url_PolicyDelete_564143,
    schemes: {Scheme.Https})
type
  Call_PolicySnippetsList_564151 = ref object of OpenApiRestCall_563556
proc url_PolicySnippetsList_564153(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicySnippetsList_564152(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all policy snippets.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   scope: JString
  ##        : Policy scope.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  var valid_564154 = query.getOrDefault("scope")
  valid_564154 = validateParameter(valid_564154, JString, required = false,
                                 default = newJString("Tenant"))
  if valid_564154 != nil:
    section.add "scope", valid_564154
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_PolicySnippetsList_564151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all policy snippets.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_PolicySnippetsList_564151; apiVersion: string;
          scope: string = "Tenant"): Recallable =
  ## policySnippetsList
  ## Lists all policy snippets.
  ##   scope: string
  ##        : Policy scope.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_564158 = newJObject()
  add(query_564158, "scope", newJString(scope))
  add(query_564158, "api-version", newJString(apiVersion))
  result = call_564157.call(nil, query_564158, nil, nil, nil)

var policySnippetsList* = Call_PolicySnippetsList_564151(
    name: "policySnippetsList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/policySnippets", validator: validate_PolicySnippetsList_564152,
    base: "", url: url_PolicySnippetsList_564153, schemes: {Scheme.Https})
type
  Call_RegionsList_564159 = ref object of OpenApiRestCall_563556
proc url_RegionsList_564161(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RegionsList_564160(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_RegionsList_564159; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all azure regions in which the service exists.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_RegionsList_564159; apiVersion: string): Recallable =
  ## regionsList
  ## Lists all azure regions in which the service exists.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_564165 = newJObject()
  add(query_564165, "api-version", newJString(apiVersion))
  result = call_564164.call(nil, query_564165, nil, nil, nil)

var regionsList* = Call_RegionsList_564159(name: "regionsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/regions",
                                        validator: validate_RegionsList_564160,
                                        base: "", url: url_RegionsList_564161,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
