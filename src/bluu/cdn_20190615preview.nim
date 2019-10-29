
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: CdnManagementClient
## version: 2019-06-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these APIs to manage Azure CDN resources through the Azure Resource Manager. You must make sure that requests made to these resources are secure.
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "cdn"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CheckNameAvailability_563787 = ref object of OpenApiRestCall_563565
proc url_CheckNameAvailability_563789(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckNameAvailability_563788(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563950 = query.getOrDefault("api-version")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "api-version", valid_563950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_563974: Call_CheckNameAvailability_563787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  let valid = call_563974.validator(path, query, header, formData, body)
  let scheme = call_563974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563974.url(scheme.get, call_563974.host, call_563974.base,
                         call_563974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563974, url, valid)

proc call*(call_564045: Call_CheckNameAvailability_563787; apiVersion: string;
          checkNameAvailabilityInput: JsonNode): Recallable =
  ## checkNameAvailability
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  var query_564046 = newJObject()
  var body_564048 = newJObject()
  add(query_564046, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInput != nil:
    body_564048 = checkNameAvailabilityInput
  result = call_564045.call(nil, query_564046, nil, nil, body_564048)

var checkNameAvailability* = Call_CheckNameAvailability_563787(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_CheckNameAvailability_563788, base: "",
    url: url_CheckNameAvailability_563789, schemes: {Scheme.Https})
type
  Call_EdgeNodesList_564087 = ref object of OpenApiRestCall_563565
proc url_EdgeNodesList_564089(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EdgeNodesList_564088(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Edgenodes are the global Point of Presence (POP) locations used to deliver CDN content to end users.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564090 = query.getOrDefault("api-version")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "api-version", valid_564090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564091: Call_EdgeNodesList_564087; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Edgenodes are the global Point of Presence (POP) locations used to deliver CDN content to end users.
  ## 
  let valid = call_564091.validator(path, query, header, formData, body)
  let scheme = call_564091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564091.url(scheme.get, call_564091.host, call_564091.base,
                         call_564091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564091, url, valid)

proc call*(call_564092: Call_EdgeNodesList_564087; apiVersion: string): Recallable =
  ## edgeNodesList
  ## Edgenodes are the global Point of Presence (POP) locations used to deliver CDN content to end users.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  var query_564093 = newJObject()
  add(query_564093, "api-version", newJString(apiVersion))
  result = call_564092.call(nil, query_564093, nil, nil, nil)

var edgeNodesList* = Call_EdgeNodesList_564087(name: "edgeNodesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/edgenodes",
    validator: validate_EdgeNodesList_564088, base: "", url: url_EdgeNodesList_564089,
    schemes: {Scheme.Https})
type
  Call_OperationsList_564094 = ref object of OpenApiRestCall_563565
proc url_OperationsList_564096(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564095(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available CDN REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_OperationsList_564094; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available CDN REST API operations.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_OperationsList_564094; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available CDN REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  result = call_564099.call(nil, query_564100, nil, nil, nil)

var operationsList* = Call_OperationsList_564094(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/operations",
    validator: validate_OperationsList_564095, base: "", url: url_OperationsList_564096,
    schemes: {Scheme.Https})
type
  Call_CheckNameAvailabilityWithSubscription_564101 = ref object of OpenApiRestCall_563565
proc url_CheckNameAvailabilityWithSubscription_564103(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Cdn/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckNameAvailabilityWithSubscription_564102(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_CheckNameAvailabilityWithSubscription_564101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_CheckNameAvailabilityWithSubscription_564101;
          apiVersion: string; subscriptionId: string;
          checkNameAvailabilityInput: JsonNode): Recallable =
  ## checkNameAvailabilityWithSubscription
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  var body_564125 = newJObject()
  add(query_564124, "api-version", newJString(apiVersion))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  if checkNameAvailabilityInput != nil:
    body_564125 = checkNameAvailabilityInput
  result = call_564122.call(path_564123, query_564124, nil, nil, body_564125)

var checkNameAvailabilityWithSubscription* = Call_CheckNameAvailabilityWithSubscription_564101(
    name: "checkNameAvailabilityWithSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_CheckNameAvailabilityWithSubscription_564102, base: "",
    url: url_CheckNameAvailabilityWithSubscription_564103, schemes: {Scheme.Https})
type
  Call_ResourceUsageList_564126 = ref object of OpenApiRestCall_563565
proc url_ResourceUsageList_564128(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Cdn/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceUsageList_564127(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ResourceUsageList_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ResourceUsageList_564126; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceUsageList
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var resourceUsageList* = Call_ResourceUsageList_564126(name: "resourceUsageList",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/checkResourceUsage",
    validator: validate_ResourceUsageList_564127, base: "",
    url: url_ResourceUsageList_564128, schemes: {Scheme.Https})
type
  Call_ProfilesList_564135 = ref object of OpenApiRestCall_563565
proc url_ProfilesList_564137(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesList_564136(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the CDN profiles within an Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
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
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_ProfilesList_564135; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within an Azure subscription.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_ProfilesList_564135; apiVersion: string;
          subscriptionId: string): Recallable =
  ## profilesList
  ## Lists all of the CDN profiles within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var profilesList* = Call_ProfilesList_564135(name: "profilesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesList_564136, base: "", url: url_ProfilesList_564137,
    schemes: {Scheme.Https})
type
  Call_ValidateProbe_564144 = ref object of OpenApiRestCall_563565
proc url_ValidateProbe_564146(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/validateProbe")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ValidateProbe_564145(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564148 = query.getOrDefault("api-version")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "api-version", valid_564148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   validateProbeInput: JObject (required)
  ##                     : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_ValidateProbe_564144; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_ValidateProbe_564144; validateProbeInput: JsonNode;
          apiVersion: string; subscriptionId: string): Recallable =
  ## validateProbe
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ##   validateProbeInput: JObject (required)
  ##                     : Input to check.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  var body_564154 = newJObject()
  if validateProbeInput != nil:
    body_564154 = validateProbeInput
  add(query_564153, "api-version", newJString(apiVersion))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  result = call_564151.call(path_564152, query_564153, nil, nil, body_564154)

var validateProbe* = Call_ValidateProbe_564144(name: "validateProbe",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/validateProbe",
    validator: validate_ValidateProbe_564145, base: "", url: url_ValidateProbe_564146,
    schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_564155 = ref object of OpenApiRestCall_563565
proc url_ProfilesListByResourceGroup_564157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListByResourceGroup_564156(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564158 = path.getOrDefault("subscriptionId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "subscriptionId", valid_564158
  var valid_564159 = path.getOrDefault("resourceGroupName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "resourceGroupName", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_ProfilesListByResourceGroup_564155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_ProfilesListByResourceGroup_564155;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesListByResourceGroup
  ## Lists all of the CDN profiles within a resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  result = call_564162.call(path_564163, query_564164, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_564155(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListByResourceGroup_564156, base: "",
    url: url_ProfilesListByResourceGroup_564157, schemes: {Scheme.Https})
type
  Call_ProfilesCreate_564176 = ref object of OpenApiRestCall_563565
proc url_ProfilesCreate_564178(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesCreate_564177(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564179 = path.getOrDefault("profileName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "profileName", valid_564179
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564182 = query.getOrDefault("api-version")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "api-version", valid_564182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   profile: JObject (required)
  ##          : Profile properties needed to create a new profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_ProfilesCreate_564176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_ProfilesCreate_564176; profileName: string;
          profile: JsonNode; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## profilesCreate
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   profile: JObject (required)
  ##          : Profile properties needed to create a new profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  var body_564188 = newJObject()
  add(path_564186, "profileName", newJString(profileName))
  if profile != nil:
    body_564188 = profile
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  result = call_564185.call(path_564186, query_564187, nil, nil, body_564188)

var profilesCreate* = Call_ProfilesCreate_564176(name: "profilesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesCreate_564177, base: "", url: url_ProfilesCreate_564178,
    schemes: {Scheme.Https})
type
  Call_ProfilesGet_564165 = ref object of OpenApiRestCall_563565
proc url_ProfilesGet_564167(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGet_564166(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564168 = path.getOrDefault("profileName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "profileName", valid_564168
  var valid_564169 = path.getOrDefault("subscriptionId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "subscriptionId", valid_564169
  var valid_564170 = path.getOrDefault("resourceGroupName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceGroupName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "api-version", valid_564171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_ProfilesGet_564165; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_ProfilesGet_564165; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesGet
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564174 = newJObject()
  var query_564175 = newJObject()
  add(path_564174, "profileName", newJString(profileName))
  add(query_564175, "api-version", newJString(apiVersion))
  add(path_564174, "subscriptionId", newJString(subscriptionId))
  add(path_564174, "resourceGroupName", newJString(resourceGroupName))
  result = call_564173.call(path_564174, query_564175, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_564165(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
                                        validator: validate_ProfilesGet_564166,
                                        base: "", url: url_ProfilesGet_564167,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_564200 = ref object of OpenApiRestCall_563565
proc url_ProfilesUpdate_564202(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesUpdate_564201(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564203 = path.getOrDefault("profileName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "profileName", valid_564203
  var valid_564204 = path.getOrDefault("subscriptionId")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "subscriptionId", valid_564204
  var valid_564205 = path.getOrDefault("resourceGroupName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "resourceGroupName", valid_564205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564206 = query.getOrDefault("api-version")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "api-version", valid_564206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   profileUpdateParameters: JObject (required)
  ##                          : Profile properties needed to update an existing profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564208: Call_ProfilesUpdate_564200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_564208.validator(path, query, header, formData, body)
  let scheme = call_564208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564208.url(scheme.get, call_564208.host, call_564208.base,
                         call_564208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564208, url, valid)

proc call*(call_564209: Call_ProfilesUpdate_564200; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          profileUpdateParameters: JsonNode): Recallable =
  ## profilesUpdate
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   profileUpdateParameters: JObject (required)
  ##                          : Profile properties needed to update an existing profile.
  var path_564210 = newJObject()
  var query_564211 = newJObject()
  var body_564212 = newJObject()
  add(path_564210, "profileName", newJString(profileName))
  add(query_564211, "api-version", newJString(apiVersion))
  add(path_564210, "subscriptionId", newJString(subscriptionId))
  add(path_564210, "resourceGroupName", newJString(resourceGroupName))
  if profileUpdateParameters != nil:
    body_564212 = profileUpdateParameters
  result = call_564209.call(path_564210, query_564211, nil, nil, body_564212)

var profilesUpdate* = Call_ProfilesUpdate_564200(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesUpdate_564201, base: "", url: url_ProfilesUpdate_564202,
    schemes: {Scheme.Https})
type
  Call_ProfilesDelete_564189 = ref object of OpenApiRestCall_563565
proc url_ProfilesDelete_564191(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesDelete_564190(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564192 = path.getOrDefault("profileName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "profileName", valid_564192
  var valid_564193 = path.getOrDefault("subscriptionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "subscriptionId", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "api-version", valid_564195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564196: Call_ProfilesDelete_564189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  let valid = call_564196.validator(path, query, header, formData, body)
  let scheme = call_564196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564196.url(scheme.get, call_564196.host, call_564196.base,
                         call_564196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564196, url, valid)

proc call*(call_564197: Call_ProfilesDelete_564189; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesDelete
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564198 = newJObject()
  var query_564199 = newJObject()
  add(path_564198, "profileName", newJString(profileName))
  add(query_564199, "api-version", newJString(apiVersion))
  add(path_564198, "subscriptionId", newJString(subscriptionId))
  add(path_564198, "resourceGroupName", newJString(resourceGroupName))
  result = call_564197.call(path_564198, query_564199, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_564189(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesDelete_564190, base: "", url: url_ProfilesDelete_564191,
    schemes: {Scheme.Https})
type
  Call_ProfilesListResourceUsage_564213 = ref object of OpenApiRestCall_563565
proc url_ProfilesListResourceUsage_564215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListResourceUsage_564214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564216 = path.getOrDefault("profileName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "profileName", valid_564216
  var valid_564217 = path.getOrDefault("subscriptionId")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "subscriptionId", valid_564217
  var valid_564218 = path.getOrDefault("resourceGroupName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "resourceGroupName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_ProfilesListResourceUsage_564213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_ProfilesListResourceUsage_564213; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesListResourceUsage
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(path_564222, "profileName", newJString(profileName))
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var profilesListResourceUsage* = Call_ProfilesListResourceUsage_564213(
    name: "profilesListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/checkResourceUsage",
    validator: validate_ProfilesListResourceUsage_564214, base: "",
    url: url_ProfilesListResourceUsage_564215, schemes: {Scheme.Https})
type
  Call_EndpointsListByProfile_564224 = ref object of OpenApiRestCall_563565
proc url_EndpointsListByProfile_564226(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsListByProfile_564225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists existing CDN endpoints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564227 = path.getOrDefault("profileName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "profileName", valid_564227
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564230 = query.getOrDefault("api-version")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "api-version", valid_564230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_EndpointsListByProfile_564224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing CDN endpoints.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_EndpointsListByProfile_564224; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## endpointsListByProfile
  ## Lists existing CDN endpoints.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(path_564233, "profileName", newJString(profileName))
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var endpointsListByProfile* = Call_EndpointsListByProfile_564224(
    name: "endpointsListByProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints",
    validator: validate_EndpointsListByProfile_564225, base: "",
    url: url_EndpointsListByProfile_564226, schemes: {Scheme.Https})
type
  Call_EndpointsCreate_564247 = ref object of OpenApiRestCall_563565
proc url_EndpointsCreate_564249(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsCreate_564248(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564250 = path.getOrDefault("profileName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "profileName", valid_564250
  var valid_564251 = path.getOrDefault("subscriptionId")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "subscriptionId", valid_564251
  var valid_564252 = path.getOrDefault("resourceGroupName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "resourceGroupName", valid_564252
  var valid_564253 = path.getOrDefault("endpointName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "endpointName", valid_564253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564254 = query.getOrDefault("api-version")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "api-version", valid_564254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpoint: JObject (required)
  ##           : Endpoint properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564256: Call_EndpointsCreate_564247; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_564256.validator(path, query, header, formData, body)
  let scheme = call_564256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564256.url(scheme.get, call_564256.host, call_564256.base,
                         call_564256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564256, url, valid)

proc call*(call_564257: Call_EndpointsCreate_564247; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string; endpoint: JsonNode): Recallable =
  ## endpointsCreate
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  ##   endpoint: JObject (required)
  ##           : Endpoint properties
  var path_564258 = newJObject()
  var query_564259 = newJObject()
  var body_564260 = newJObject()
  add(path_564258, "profileName", newJString(profileName))
  add(query_564259, "api-version", newJString(apiVersion))
  add(path_564258, "subscriptionId", newJString(subscriptionId))
  add(path_564258, "resourceGroupName", newJString(resourceGroupName))
  add(path_564258, "endpointName", newJString(endpointName))
  if endpoint != nil:
    body_564260 = endpoint
  result = call_564257.call(path_564258, query_564259, nil, nil, body_564260)

var endpointsCreate* = Call_EndpointsCreate_564247(name: "endpointsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsCreate_564248, base: "", url: url_EndpointsCreate_564249,
    schemes: {Scheme.Https})
type
  Call_EndpointsGet_564235 = ref object of OpenApiRestCall_563565
proc url_EndpointsGet_564237(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsGet_564236(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564238 = path.getOrDefault("profileName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "profileName", valid_564238
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("resourceGroupName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "resourceGroupName", valid_564240
  var valid_564241 = path.getOrDefault("endpointName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "endpointName", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564243: Call_EndpointsGet_564235; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_EndpointsGet_564235; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## endpointsGet
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564245 = newJObject()
  var query_564246 = newJObject()
  add(path_564245, "profileName", newJString(profileName))
  add(query_564246, "api-version", newJString(apiVersion))
  add(path_564245, "subscriptionId", newJString(subscriptionId))
  add(path_564245, "resourceGroupName", newJString(resourceGroupName))
  add(path_564245, "endpointName", newJString(endpointName))
  result = call_564244.call(path_564245, query_564246, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_564235(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsGet_564236, base: "", url: url_EndpointsGet_564237,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_564273 = ref object of OpenApiRestCall_563565
proc url_EndpointsUpdate_564275(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsUpdate_564274(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564276 = path.getOrDefault("profileName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "profileName", valid_564276
  var valid_564277 = path.getOrDefault("subscriptionId")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "subscriptionId", valid_564277
  var valid_564278 = path.getOrDefault("resourceGroupName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "resourceGroupName", valid_564278
  var valid_564279 = path.getOrDefault("endpointName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "endpointName", valid_564279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564280 = query.getOrDefault("api-version")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "api-version", valid_564280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpointUpdateProperties: JObject (required)
  ##                           : Endpoint update properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564282: Call_EndpointsUpdate_564273; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_EndpointsUpdate_564273; profileName: string;
          apiVersion: string; endpointUpdateProperties: JsonNode;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## endpointsUpdate
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   endpointUpdateProperties: JObject (required)
  ##                           : Endpoint update properties
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564284 = newJObject()
  var query_564285 = newJObject()
  var body_564286 = newJObject()
  add(path_564284, "profileName", newJString(profileName))
  add(query_564285, "api-version", newJString(apiVersion))
  if endpointUpdateProperties != nil:
    body_564286 = endpointUpdateProperties
  add(path_564284, "subscriptionId", newJString(subscriptionId))
  add(path_564284, "resourceGroupName", newJString(resourceGroupName))
  add(path_564284, "endpointName", newJString(endpointName))
  result = call_564283.call(path_564284, query_564285, nil, nil, body_564286)

var endpointsUpdate* = Call_EndpointsUpdate_564273(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsUpdate_564274, base: "", url: url_EndpointsUpdate_564275,
    schemes: {Scheme.Https})
type
  Call_EndpointsDelete_564261 = ref object of OpenApiRestCall_563565
proc url_EndpointsDelete_564263(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsDelete_564262(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564264 = path.getOrDefault("profileName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "profileName", valid_564264
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("resourceGroupName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "resourceGroupName", valid_564266
  var valid_564267 = path.getOrDefault("endpointName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "endpointName", valid_564267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "api-version", valid_564268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564269: Call_EndpointsDelete_564261; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_EndpointsDelete_564261; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## endpointsDelete
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  add(path_564271, "profileName", newJString(profileName))
  add(query_564272, "api-version", newJString(apiVersion))
  add(path_564271, "subscriptionId", newJString(subscriptionId))
  add(path_564271, "resourceGroupName", newJString(resourceGroupName))
  add(path_564271, "endpointName", newJString(endpointName))
  result = call_564270.call(path_564271, query_564272, nil, nil, nil)

var endpointsDelete* = Call_EndpointsDelete_564261(name: "endpointsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsDelete_564262, base: "", url: url_EndpointsDelete_564263,
    schemes: {Scheme.Https})
type
  Call_EndpointsListResourceUsage_564287 = ref object of OpenApiRestCall_563565
proc url_EndpointsListResourceUsage_564289(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsListResourceUsage_564288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564290 = path.getOrDefault("profileName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "profileName", valid_564290
  var valid_564291 = path.getOrDefault("subscriptionId")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "subscriptionId", valid_564291
  var valid_564292 = path.getOrDefault("resourceGroupName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "resourceGroupName", valid_564292
  var valid_564293 = path.getOrDefault("endpointName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "endpointName", valid_564293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564294 = query.getOrDefault("api-version")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "api-version", valid_564294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564295: Call_EndpointsListResourceUsage_564287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  let valid = call_564295.validator(path, query, header, formData, body)
  let scheme = call_564295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564295.url(scheme.get, call_564295.host, call_564295.base,
                         call_564295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564295, url, valid)

proc call*(call_564296: Call_EndpointsListResourceUsage_564287;
          profileName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; endpointName: string): Recallable =
  ## endpointsListResourceUsage
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564297 = newJObject()
  var query_564298 = newJObject()
  add(path_564297, "profileName", newJString(profileName))
  add(query_564298, "api-version", newJString(apiVersion))
  add(path_564297, "subscriptionId", newJString(subscriptionId))
  add(path_564297, "resourceGroupName", newJString(resourceGroupName))
  add(path_564297, "endpointName", newJString(endpointName))
  result = call_564296.call(path_564297, query_564298, nil, nil, nil)

var endpointsListResourceUsage* = Call_EndpointsListResourceUsage_564287(
    name: "endpointsListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/checkResourceUsage",
    validator: validate_EndpointsListResourceUsage_564288, base: "",
    url: url_EndpointsListResourceUsage_564289, schemes: {Scheme.Https})
type
  Call_CustomDomainsListByEndpoint_564299 = ref object of OpenApiRestCall_563565
proc url_CustomDomainsListByEndpoint_564301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsListByEndpoint_564300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564302 = path.getOrDefault("profileName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "profileName", valid_564302
  var valid_564303 = path.getOrDefault("subscriptionId")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "subscriptionId", valid_564303
  var valid_564304 = path.getOrDefault("resourceGroupName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "resourceGroupName", valid_564304
  var valid_564305 = path.getOrDefault("endpointName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "endpointName", valid_564305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "api-version", valid_564306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564307: Call_CustomDomainsListByEndpoint_564299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  let valid = call_564307.validator(path, query, header, formData, body)
  let scheme = call_564307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564307.url(scheme.get, call_564307.host, call_564307.base,
                         call_564307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564307, url, valid)

proc call*(call_564308: Call_CustomDomainsListByEndpoint_564299;
          profileName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsListByEndpoint
  ## Lists all of the existing custom domains within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564309 = newJObject()
  var query_564310 = newJObject()
  add(path_564309, "profileName", newJString(profileName))
  add(query_564310, "api-version", newJString(apiVersion))
  add(path_564309, "subscriptionId", newJString(subscriptionId))
  add(path_564309, "resourceGroupName", newJString(resourceGroupName))
  add(path_564309, "endpointName", newJString(endpointName))
  result = call_564308.call(path_564309, query_564310, nil, nil, nil)

var customDomainsListByEndpoint* = Call_CustomDomainsListByEndpoint_564299(
    name: "customDomainsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains",
    validator: validate_CustomDomainsListByEndpoint_564300, base: "",
    url: url_CustomDomainsListByEndpoint_564301, schemes: {Scheme.Https})
type
  Call_CustomDomainsCreate_564324 = ref object of OpenApiRestCall_563565
proc url_CustomDomainsCreate_564326(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsCreate_564325(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564327 = path.getOrDefault("customDomainName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "customDomainName", valid_564327
  var valid_564328 = path.getOrDefault("profileName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "profileName", valid_564328
  var valid_564329 = path.getOrDefault("subscriptionId")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "subscriptionId", valid_564329
  var valid_564330 = path.getOrDefault("resourceGroupName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "resourceGroupName", valid_564330
  var valid_564331 = path.getOrDefault("endpointName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "endpointName", valid_564331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564332 = query.getOrDefault("api-version")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "api-version", valid_564332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Properties required to create a new custom domain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_CustomDomainsCreate_564324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new custom domain within an endpoint.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_CustomDomainsCreate_564324; customDomainName: string;
          profileName: string; apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsCreate
  ## Creates a new custom domain within an endpoint.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   customDomainProperties: JObject (required)
  ##                         : Properties required to create a new custom domain.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  var body_564338 = newJObject()
  add(path_564336, "customDomainName", newJString(customDomainName))
  add(path_564336, "profileName", newJString(profileName))
  add(query_564337, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_564338 = customDomainProperties
  add(path_564336, "subscriptionId", newJString(subscriptionId))
  add(path_564336, "resourceGroupName", newJString(resourceGroupName))
  add(path_564336, "endpointName", newJString(endpointName))
  result = call_564335.call(path_564336, query_564337, nil, nil, body_564338)

var customDomainsCreate* = Call_CustomDomainsCreate_564324(
    name: "customDomainsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsCreate_564325, base: "",
    url: url_CustomDomainsCreate_564326, schemes: {Scheme.Https})
type
  Call_CustomDomainsGet_564311 = ref object of OpenApiRestCall_563565
proc url_CustomDomainsGet_564313(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsGet_564312(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets an existing custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564314 = path.getOrDefault("customDomainName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "customDomainName", valid_564314
  var valid_564315 = path.getOrDefault("profileName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "profileName", valid_564315
  var valid_564316 = path.getOrDefault("subscriptionId")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "subscriptionId", valid_564316
  var valid_564317 = path.getOrDefault("resourceGroupName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "resourceGroupName", valid_564317
  var valid_564318 = path.getOrDefault("endpointName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "endpointName", valid_564318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564319 = query.getOrDefault("api-version")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "api-version", valid_564319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564320: Call_CustomDomainsGet_564311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing custom domain within an endpoint.
  ## 
  let valid = call_564320.validator(path, query, header, formData, body)
  let scheme = call_564320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564320.url(scheme.get, call_564320.host, call_564320.base,
                         call_564320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564320, url, valid)

proc call*(call_564321: Call_CustomDomainsGet_564311; customDomainName: string;
          profileName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsGet
  ## Gets an existing custom domain within an endpoint.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564322 = newJObject()
  var query_564323 = newJObject()
  add(path_564322, "customDomainName", newJString(customDomainName))
  add(path_564322, "profileName", newJString(profileName))
  add(query_564323, "api-version", newJString(apiVersion))
  add(path_564322, "subscriptionId", newJString(subscriptionId))
  add(path_564322, "resourceGroupName", newJString(resourceGroupName))
  add(path_564322, "endpointName", newJString(endpointName))
  result = call_564321.call(path_564322, query_564323, nil, nil, nil)

var customDomainsGet* = Call_CustomDomainsGet_564311(name: "customDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsGet_564312, base: "",
    url: url_CustomDomainsGet_564313, schemes: {Scheme.Https})
type
  Call_CustomDomainsDelete_564339 = ref object of OpenApiRestCall_563565
proc url_CustomDomainsDelete_564341(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsDelete_564340(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564342 = path.getOrDefault("customDomainName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "customDomainName", valid_564342
  var valid_564343 = path.getOrDefault("profileName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "profileName", valid_564343
  var valid_564344 = path.getOrDefault("subscriptionId")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "subscriptionId", valid_564344
  var valid_564345 = path.getOrDefault("resourceGroupName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "resourceGroupName", valid_564345
  var valid_564346 = path.getOrDefault("endpointName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "endpointName", valid_564346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564347 = query.getOrDefault("api-version")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "api-version", valid_564347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564348: Call_CustomDomainsDelete_564339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_CustomDomainsDelete_564339; customDomainName: string;
          profileName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsDelete
  ## Deletes an existing custom domain within an endpoint.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564350 = newJObject()
  var query_564351 = newJObject()
  add(path_564350, "customDomainName", newJString(customDomainName))
  add(path_564350, "profileName", newJString(profileName))
  add(query_564351, "api-version", newJString(apiVersion))
  add(path_564350, "subscriptionId", newJString(subscriptionId))
  add(path_564350, "resourceGroupName", newJString(resourceGroupName))
  add(path_564350, "endpointName", newJString(endpointName))
  result = call_564349.call(path_564350, query_564351, nil, nil, nil)

var customDomainsDelete* = Call_CustomDomainsDelete_564339(
    name: "customDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsDelete_564340, base: "",
    url: url_CustomDomainsDelete_564341, schemes: {Scheme.Https})
type
  Call_CustomDomainsDisableCustomHttps_564352 = ref object of OpenApiRestCall_563565
proc url_CustomDomainsDisableCustomHttps_564354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName"),
               (kind: ConstantSegment, value: "/disableCustomHttps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsDisableCustomHttps_564353(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable https delivery of the custom domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564355 = path.getOrDefault("customDomainName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "customDomainName", valid_564355
  var valid_564356 = path.getOrDefault("profileName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "profileName", valid_564356
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("resourceGroupName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "resourceGroupName", valid_564358
  var valid_564359 = path.getOrDefault("endpointName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "endpointName", valid_564359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564360 = query.getOrDefault("api-version")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "api-version", valid_564360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564361: Call_CustomDomainsDisableCustomHttps_564352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable https delivery of the custom domain.
  ## 
  let valid = call_564361.validator(path, query, header, formData, body)
  let scheme = call_564361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564361.url(scheme.get, call_564361.host, call_564361.base,
                         call_564361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564361, url, valid)

proc call*(call_564362: Call_CustomDomainsDisableCustomHttps_564352;
          customDomainName: string; profileName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsDisableCustomHttps
  ## Disable https delivery of the custom domain.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564363 = newJObject()
  var query_564364 = newJObject()
  add(path_564363, "customDomainName", newJString(customDomainName))
  add(path_564363, "profileName", newJString(profileName))
  add(query_564364, "api-version", newJString(apiVersion))
  add(path_564363, "subscriptionId", newJString(subscriptionId))
  add(path_564363, "resourceGroupName", newJString(resourceGroupName))
  add(path_564363, "endpointName", newJString(endpointName))
  result = call_564362.call(path_564363, query_564364, nil, nil, nil)

var customDomainsDisableCustomHttps* = Call_CustomDomainsDisableCustomHttps_564352(
    name: "customDomainsDisableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/disableCustomHttps",
    validator: validate_CustomDomainsDisableCustomHttps_564353, base: "",
    url: url_CustomDomainsDisableCustomHttps_564354, schemes: {Scheme.Https})
type
  Call_CustomDomainsEnableCustomHttps_564365 = ref object of OpenApiRestCall_563565
proc url_CustomDomainsEnableCustomHttps_564367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName"),
               (kind: ConstantSegment, value: "/enableCustomHttps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsEnableCustomHttps_564366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable https delivery of the custom domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564385 = path.getOrDefault("customDomainName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "customDomainName", valid_564385
  var valid_564386 = path.getOrDefault("profileName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "profileName", valid_564386
  var valid_564387 = path.getOrDefault("subscriptionId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "subscriptionId", valid_564387
  var valid_564388 = path.getOrDefault("resourceGroupName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "resourceGroupName", valid_564388
  var valid_564389 = path.getOrDefault("endpointName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "endpointName", valid_564389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564390 = query.getOrDefault("api-version")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "api-version", valid_564390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainHttpsParameters: JObject
  ##                              : The configuration specifying how to enable HTTPS for the custom domain - using CDN managed certificate or user's own certificate. If not specified, enabling ssl uses CDN managed certificate by default.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564392: Call_CustomDomainsEnableCustomHttps_564365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable https delivery of the custom domain.
  ## 
  let valid = call_564392.validator(path, query, header, formData, body)
  let scheme = call_564392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564392.url(scheme.get, call_564392.host, call_564392.base,
                         call_564392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564392, url, valid)

proc call*(call_564393: Call_CustomDomainsEnableCustomHttps_564365;
          customDomainName: string; profileName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; endpointName: string;
          customDomainHttpsParameters: JsonNode = nil): Recallable =
  ## customDomainsEnableCustomHttps
  ## Enable https delivery of the custom domain.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   customDomainHttpsParameters: JObject
  ##                              : The configuration specifying how to enable HTTPS for the custom domain - using CDN managed certificate or user's own certificate. If not specified, enabling ssl uses CDN managed certificate by default.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564394 = newJObject()
  var query_564395 = newJObject()
  var body_564396 = newJObject()
  add(path_564394, "customDomainName", newJString(customDomainName))
  add(path_564394, "profileName", newJString(profileName))
  add(query_564395, "api-version", newJString(apiVersion))
  add(path_564394, "subscriptionId", newJString(subscriptionId))
  add(path_564394, "resourceGroupName", newJString(resourceGroupName))
  if customDomainHttpsParameters != nil:
    body_564396 = customDomainHttpsParameters
  add(path_564394, "endpointName", newJString(endpointName))
  result = call_564393.call(path_564394, query_564395, nil, nil, body_564396)

var customDomainsEnableCustomHttps* = Call_CustomDomainsEnableCustomHttps_564365(
    name: "customDomainsEnableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/enableCustomHttps",
    validator: validate_CustomDomainsEnableCustomHttps_564366, base: "",
    url: url_CustomDomainsEnableCustomHttps_564367, schemes: {Scheme.Https})
type
  Call_EndpointsLoadContent_564397 = ref object of OpenApiRestCall_563565
proc url_EndpointsLoadContent_564399(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/load")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsLoadContent_564398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564400 = path.getOrDefault("profileName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "profileName", valid_564400
  var valid_564401 = path.getOrDefault("subscriptionId")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "subscriptionId", valid_564401
  var valid_564402 = path.getOrDefault("resourceGroupName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "resourceGroupName", valid_564402
  var valid_564403 = path.getOrDefault("endpointName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "endpointName", valid_564403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564404 = query.getOrDefault("api-version")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "api-version", valid_564404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should be a full URL, e.g. ‘/pictures/city.png' which loads a single file 
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564406: Call_EndpointsLoadContent_564397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  let valid = call_564406.validator(path, query, header, formData, body)
  let scheme = call_564406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564406.url(scheme.get, call_564406.host, call_564406.base,
                         call_564406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564406, url, valid)

proc call*(call_564407: Call_EndpointsLoadContent_564397;
          contentFilePaths: JsonNode; profileName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## endpointsLoadContent
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should be a full URL, e.g. ‘/pictures/city.png' which loads a single file 
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564408 = newJObject()
  var query_564409 = newJObject()
  var body_564410 = newJObject()
  if contentFilePaths != nil:
    body_564410 = contentFilePaths
  add(path_564408, "profileName", newJString(profileName))
  add(query_564409, "api-version", newJString(apiVersion))
  add(path_564408, "subscriptionId", newJString(subscriptionId))
  add(path_564408, "resourceGroupName", newJString(resourceGroupName))
  add(path_564408, "endpointName", newJString(endpointName))
  result = call_564407.call(path_564408, query_564409, nil, nil, body_564410)

var endpointsLoadContent* = Call_EndpointsLoadContent_564397(
    name: "endpointsLoadContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/load",
    validator: validate_EndpointsLoadContent_564398, base: "",
    url: url_EndpointsLoadContent_564399, schemes: {Scheme.Https})
type
  Call_OriginsListByEndpoint_564411 = ref object of OpenApiRestCall_563565
proc url_OriginsListByEndpoint_564413(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsListByEndpoint_564412(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the existing origins within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564414 = path.getOrDefault("profileName")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "profileName", valid_564414
  var valid_564415 = path.getOrDefault("subscriptionId")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "subscriptionId", valid_564415
  var valid_564416 = path.getOrDefault("resourceGroupName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "resourceGroupName", valid_564416
  var valid_564417 = path.getOrDefault("endpointName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "endpointName", valid_564417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
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

proc call*(call_564419: Call_OriginsListByEndpoint_564411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing origins within an endpoint.
  ## 
  let valid = call_564419.validator(path, query, header, formData, body)
  let scheme = call_564419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564419.url(scheme.get, call_564419.host, call_564419.base,
                         call_564419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564419, url, valid)

proc call*(call_564420: Call_OriginsListByEndpoint_564411; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## originsListByEndpoint
  ## Lists all of the existing origins within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564421 = newJObject()
  var query_564422 = newJObject()
  add(path_564421, "profileName", newJString(profileName))
  add(query_564422, "api-version", newJString(apiVersion))
  add(path_564421, "subscriptionId", newJString(subscriptionId))
  add(path_564421, "resourceGroupName", newJString(resourceGroupName))
  add(path_564421, "endpointName", newJString(endpointName))
  result = call_564420.call(path_564421, query_564422, nil, nil, nil)

var originsListByEndpoint* = Call_OriginsListByEndpoint_564411(
    name: "originsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins",
    validator: validate_OriginsListByEndpoint_564412, base: "",
    url: url_OriginsListByEndpoint_564413, schemes: {Scheme.Https})
type
  Call_OriginsGet_564423 = ref object of OpenApiRestCall_563565
proc url_OriginsGet_564425(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "originName" in path, "`originName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins/"),
               (kind: VariableSegment, value: "originName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsGet_564424(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing origin within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564426 = path.getOrDefault("profileName")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "profileName", valid_564426
  var valid_564427 = path.getOrDefault("subscriptionId")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "subscriptionId", valid_564427
  var valid_564428 = path.getOrDefault("resourceGroupName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "resourceGroupName", valid_564428
  var valid_564429 = path.getOrDefault("originName")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "originName", valid_564429
  var valid_564430 = path.getOrDefault("endpointName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "endpointName", valid_564430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564431 = query.getOrDefault("api-version")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "api-version", valid_564431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564432: Call_OriginsGet_564423; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing origin within an endpoint.
  ## 
  let valid = call_564432.validator(path, query, header, formData, body)
  let scheme = call_564432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564432.url(scheme.get, call_564432.host, call_564432.base,
                         call_564432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564432, url, valid)

proc call*(call_564433: Call_OriginsGet_564423; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          originName: string; endpointName: string): Recallable =
  ## originsGet
  ## Gets an existing origin within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: string (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564434 = newJObject()
  var query_564435 = newJObject()
  add(path_564434, "profileName", newJString(profileName))
  add(query_564435, "api-version", newJString(apiVersion))
  add(path_564434, "subscriptionId", newJString(subscriptionId))
  add(path_564434, "resourceGroupName", newJString(resourceGroupName))
  add(path_564434, "originName", newJString(originName))
  add(path_564434, "endpointName", newJString(endpointName))
  result = call_564433.call(path_564434, query_564435, nil, nil, nil)

var originsGet* = Call_OriginsGet_564423(name: "originsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
                                      validator: validate_OriginsGet_564424,
                                      base: "", url: url_OriginsGet_564425,
                                      schemes: {Scheme.Https})
type
  Call_OriginsUpdate_564436 = ref object of OpenApiRestCall_563565
proc url_OriginsUpdate_564438(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "originName" in path, "`originName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins/"),
               (kind: VariableSegment, value: "originName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsUpdate_564437(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing origin within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564439 = path.getOrDefault("profileName")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "profileName", valid_564439
  var valid_564440 = path.getOrDefault("subscriptionId")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "subscriptionId", valid_564440
  var valid_564441 = path.getOrDefault("resourceGroupName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "resourceGroupName", valid_564441
  var valid_564442 = path.getOrDefault("originName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "originName", valid_564442
  var valid_564443 = path.getOrDefault("endpointName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "endpointName", valid_564443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564444 = query.getOrDefault("api-version")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "api-version", valid_564444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   originUpdateProperties: JObject (required)
  ##                         : Origin properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564446: Call_OriginsUpdate_564436; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing origin within an endpoint.
  ## 
  let valid = call_564446.validator(path, query, header, formData, body)
  let scheme = call_564446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564446.url(scheme.get, call_564446.host, call_564446.base,
                         call_564446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564446, url, valid)

proc call*(call_564447: Call_OriginsUpdate_564436; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          originName: string; originUpdateProperties: JsonNode; endpointName: string): Recallable =
  ## originsUpdate
  ## Updates an existing origin within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: string (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   originUpdateProperties: JObject (required)
  ##                         : Origin properties
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564448 = newJObject()
  var query_564449 = newJObject()
  var body_564450 = newJObject()
  add(path_564448, "profileName", newJString(profileName))
  add(query_564449, "api-version", newJString(apiVersion))
  add(path_564448, "subscriptionId", newJString(subscriptionId))
  add(path_564448, "resourceGroupName", newJString(resourceGroupName))
  add(path_564448, "originName", newJString(originName))
  if originUpdateProperties != nil:
    body_564450 = originUpdateProperties
  add(path_564448, "endpointName", newJString(endpointName))
  result = call_564447.call(path_564448, query_564449, nil, nil, body_564450)

var originsUpdate* = Call_OriginsUpdate_564436(name: "originsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsUpdate_564437, base: "", url: url_OriginsUpdate_564438,
    schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_564451 = ref object of OpenApiRestCall_563565
proc url_EndpointsPurgeContent_564453(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsPurgeContent_564452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a content from CDN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564454 = path.getOrDefault("profileName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "profileName", valid_564454
  var valid_564455 = path.getOrDefault("subscriptionId")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "subscriptionId", valid_564455
  var valid_564456 = path.getOrDefault("resourceGroupName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "resourceGroupName", valid_564456
  var valid_564457 = path.getOrDefault("endpointName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "endpointName", valid_564457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564458 = query.getOrDefault("api-version")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "api-version", valid_564458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564460: Call_EndpointsPurgeContent_564451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a content from CDN.
  ## 
  let valid = call_564460.validator(path, query, header, formData, body)
  let scheme = call_564460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564460.url(scheme.get, call_564460.host, call_564460.base,
                         call_564460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564460, url, valid)

proc call*(call_564461: Call_EndpointsPurgeContent_564451;
          contentFilePaths: JsonNode; profileName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## endpointsPurgeContent
  ## Removes a content from CDN.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564462 = newJObject()
  var query_564463 = newJObject()
  var body_564464 = newJObject()
  if contentFilePaths != nil:
    body_564464 = contentFilePaths
  add(path_564462, "profileName", newJString(profileName))
  add(query_564463, "api-version", newJString(apiVersion))
  add(path_564462, "subscriptionId", newJString(subscriptionId))
  add(path_564462, "resourceGroupName", newJString(resourceGroupName))
  add(path_564462, "endpointName", newJString(endpointName))
  result = call_564461.call(path_564462, query_564463, nil, nil, body_564464)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_564451(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/purge",
    validator: validate_EndpointsPurgeContent_564452, base: "",
    url: url_EndpointsPurgeContent_564453, schemes: {Scheme.Https})
type
  Call_EndpointsStart_564465 = ref object of OpenApiRestCall_563565
proc url_EndpointsStart_564467(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsStart_564466(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564468 = path.getOrDefault("profileName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "profileName", valid_564468
  var valid_564469 = path.getOrDefault("subscriptionId")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "subscriptionId", valid_564469
  var valid_564470 = path.getOrDefault("resourceGroupName")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "resourceGroupName", valid_564470
  var valid_564471 = path.getOrDefault("endpointName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "endpointName", valid_564471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564472 = query.getOrDefault("api-version")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "api-version", valid_564472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564473: Call_EndpointsStart_564465; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  let valid = call_564473.validator(path, query, header, formData, body)
  let scheme = call_564473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564473.url(scheme.get, call_564473.host, call_564473.base,
                         call_564473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564473, url, valid)

proc call*(call_564474: Call_EndpointsStart_564465; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## endpointsStart
  ## Starts an existing CDN endpoint that is on a stopped state.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564475 = newJObject()
  var query_564476 = newJObject()
  add(path_564475, "profileName", newJString(profileName))
  add(query_564476, "api-version", newJString(apiVersion))
  add(path_564475, "subscriptionId", newJString(subscriptionId))
  add(path_564475, "resourceGroupName", newJString(resourceGroupName))
  add(path_564475, "endpointName", newJString(endpointName))
  result = call_564474.call(path_564475, query_564476, nil, nil, nil)

var endpointsStart* = Call_EndpointsStart_564465(name: "endpointsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/start",
    validator: validate_EndpointsStart_564466, base: "", url: url_EndpointsStart_564467,
    schemes: {Scheme.Https})
type
  Call_EndpointsStop_564477 = ref object of OpenApiRestCall_563565
proc url_EndpointsStop_564479(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsStop_564478(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an existing running CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564480 = path.getOrDefault("profileName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "profileName", valid_564480
  var valid_564481 = path.getOrDefault("subscriptionId")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "subscriptionId", valid_564481
  var valid_564482 = path.getOrDefault("resourceGroupName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "resourceGroupName", valid_564482
  var valid_564483 = path.getOrDefault("endpointName")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "endpointName", valid_564483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564484 = query.getOrDefault("api-version")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "api-version", valid_564484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564485: Call_EndpointsStop_564477; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing running CDN endpoint.
  ## 
  let valid = call_564485.validator(path, query, header, formData, body)
  let scheme = call_564485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564485.url(scheme.get, call_564485.host, call_564485.base,
                         call_564485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564485, url, valid)

proc call*(call_564486: Call_EndpointsStop_564477; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## endpointsStop
  ## Stops an existing running CDN endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564487 = newJObject()
  var query_564488 = newJObject()
  add(path_564487, "profileName", newJString(profileName))
  add(query_564488, "api-version", newJString(apiVersion))
  add(path_564487, "subscriptionId", newJString(subscriptionId))
  add(path_564487, "resourceGroupName", newJString(resourceGroupName))
  add(path_564487, "endpointName", newJString(endpointName))
  result = call_564486.call(path_564487, query_564488, nil, nil, nil)

var endpointsStop* = Call_EndpointsStop_564477(name: "endpointsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/stop",
    validator: validate_EndpointsStop_564478, base: "", url: url_EndpointsStop_564479,
    schemes: {Scheme.Https})
type
  Call_EndpointsValidateCustomDomain_564489 = ref object of OpenApiRestCall_563565
proc url_EndpointsValidateCustomDomain_564491(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/validateCustomDomain")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsValidateCustomDomain_564490(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564492 = path.getOrDefault("profileName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "profileName", valid_564492
  var valid_564493 = path.getOrDefault("subscriptionId")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "subscriptionId", valid_564493
  var valid_564494 = path.getOrDefault("resourceGroupName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "resourceGroupName", valid_564494
  var valid_564495 = path.getOrDefault("endpointName")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "endpointName", valid_564495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564496 = query.getOrDefault("api-version")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "api-version", valid_564496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564498: Call_EndpointsValidateCustomDomain_564489; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  let valid = call_564498.validator(path, query, header, formData, body)
  let scheme = call_564498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564498.url(scheme.get, call_564498.host, call_564498.base,
                         call_564498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564498, url, valid)

proc call*(call_564499: Call_EndpointsValidateCustomDomain_564489;
          profileName: string; apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## endpointsValidateCustomDomain
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_564500 = newJObject()
  var query_564501 = newJObject()
  var body_564502 = newJObject()
  add(path_564500, "profileName", newJString(profileName))
  add(query_564501, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_564502 = customDomainProperties
  add(path_564500, "subscriptionId", newJString(subscriptionId))
  add(path_564500, "resourceGroupName", newJString(resourceGroupName))
  add(path_564500, "endpointName", newJString(endpointName))
  result = call_564499.call(path_564500, query_564501, nil, nil, body_564502)

var endpointsValidateCustomDomain* = Call_EndpointsValidateCustomDomain_564489(
    name: "endpointsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/validateCustomDomain",
    validator: validate_EndpointsValidateCustomDomain_564490, base: "",
    url: url_EndpointsValidateCustomDomain_564491, schemes: {Scheme.Https})
type
  Call_ProfilesGenerateSsoUri_564503 = ref object of OpenApiRestCall_563565
proc url_ProfilesGenerateSsoUri_564505(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/generateSsoUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGenerateSsoUri_564504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564506 = path.getOrDefault("profileName")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "profileName", valid_564506
  var valid_564507 = path.getOrDefault("subscriptionId")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "subscriptionId", valid_564507
  var valid_564508 = path.getOrDefault("resourceGroupName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "resourceGroupName", valid_564508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564509 = query.getOrDefault("api-version")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "api-version", valid_564509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564510: Call_ProfilesGenerateSsoUri_564503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  let valid = call_564510.validator(path, query, header, formData, body)
  let scheme = call_564510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564510.url(scheme.get, call_564510.host, call_564510.base,
                         call_564510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564510, url, valid)

proc call*(call_564511: Call_ProfilesGenerateSsoUri_564503; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesGenerateSsoUri
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564512 = newJObject()
  var query_564513 = newJObject()
  add(path_564512, "profileName", newJString(profileName))
  add(query_564513, "api-version", newJString(apiVersion))
  add(path_564512, "subscriptionId", newJString(subscriptionId))
  add(path_564512, "resourceGroupName", newJString(resourceGroupName))
  result = call_564511.call(path_564512, query_564513, nil, nil, nil)

var profilesGenerateSsoUri* = Call_ProfilesGenerateSsoUri_564503(
    name: "profilesGenerateSsoUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/generateSsoUri",
    validator: validate_ProfilesGenerateSsoUri_564504, base: "",
    url: url_ProfilesGenerateSsoUri_564505, schemes: {Scheme.Https})
type
  Call_ProfilesListSupportedOptimizationTypes_564514 = ref object of OpenApiRestCall_563565
proc url_ProfilesListSupportedOptimizationTypes_564516(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/getSupportedOptimizationTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListSupportedOptimizationTypes_564515(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564517 = path.getOrDefault("profileName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "profileName", valid_564517
  var valid_564518 = path.getOrDefault("subscriptionId")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "subscriptionId", valid_564518
  var valid_564519 = path.getOrDefault("resourceGroupName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "resourceGroupName", valid_564519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564520 = query.getOrDefault("api-version")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "api-version", valid_564520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564521: Call_ProfilesListSupportedOptimizationTypes_564514;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  let valid = call_564521.validator(path, query, header, formData, body)
  let scheme = call_564521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564521.url(scheme.get, call_564521.host, call_564521.base,
                         call_564521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564521, url, valid)

proc call*(call_564522: Call_ProfilesListSupportedOptimizationTypes_564514;
          profileName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## profilesListSupportedOptimizationTypes
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564523 = newJObject()
  var query_564524 = newJObject()
  add(path_564523, "profileName", newJString(profileName))
  add(query_564524, "api-version", newJString(apiVersion))
  add(path_564523, "subscriptionId", newJString(subscriptionId))
  add(path_564523, "resourceGroupName", newJString(resourceGroupName))
  result = call_564522.call(path_564523, query_564524, nil, nil, nil)

var profilesListSupportedOptimizationTypes* = Call_ProfilesListSupportedOptimizationTypes_564514(
    name: "profilesListSupportedOptimizationTypes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/getSupportedOptimizationTypes",
    validator: validate_ProfilesListSupportedOptimizationTypes_564515, base: "",
    url: url_ProfilesListSupportedOptimizationTypes_564516,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
