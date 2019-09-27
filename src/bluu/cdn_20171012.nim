
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CdnManagementClient
## version: 2017-10-12
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "cdn"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CheckNameAvailability_593660 = ref object of OpenApiRestCall_593438
proc url_CheckNameAvailability_593662(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckNameAvailability_593661(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "api-version", valid_593821
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

proc call*(call_593845: Call_CheckNameAvailability_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_CheckNameAvailability_593660; apiVersion: string;
          checkNameAvailabilityInput: JsonNode): Recallable =
  ## checkNameAvailability
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  var query_593917 = newJObject()
  var body_593919 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInput != nil:
    body_593919 = checkNameAvailabilityInput
  result = call_593916.call(nil, query_593917, nil, nil, body_593919)

var checkNameAvailability* = Call_CheckNameAvailability_593660(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_CheckNameAvailability_593661, base: "",
    url: url_CheckNameAvailability_593662, schemes: {Scheme.Https})
type
  Call_EdgeNodesList_593958 = ref object of OpenApiRestCall_593438
proc url_EdgeNodesList_593960(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EdgeNodesList_593959(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_EdgeNodesList_593958; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Edgenodes are the global Point of Presence (POP) locations used to deliver CDN content to end users.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_EdgeNodesList_593958; apiVersion: string): Recallable =
  ## edgeNodesList
  ## Edgenodes are the global Point of Presence (POP) locations used to deliver CDN content to end users.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  result = call_593963.call(nil, query_593964, nil, nil, nil)

var edgeNodesList* = Call_EdgeNodesList_593958(name: "edgeNodesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/edgenodes",
    validator: validate_EdgeNodesList_593959, base: "", url: url_EdgeNodesList_593960,
    schemes: {Scheme.Https})
type
  Call_OperationsList_593965 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593967(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593966(path: JsonNode; query: JsonNode;
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
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_OperationsList_593965; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available CDN REST API operations.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_OperationsList_593965; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available CDN REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  var query_593971 = newJObject()
  add(query_593971, "api-version", newJString(apiVersion))
  result = call_593970.call(nil, query_593971, nil, nil, nil)

var operationsList* = Call_OperationsList_593965(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/operations",
    validator: validate_OperationsList_593966, base: "", url: url_OperationsList_593967,
    schemes: {Scheme.Https})
type
  Call_CheckNameAvailabilityWithSubscription_593972 = ref object of OpenApiRestCall_593438
proc url_CheckNameAvailabilityWithSubscription_593974(protocol: Scheme;
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

proc validate_CheckNameAvailabilityWithSubscription_593973(path: JsonNode;
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
  var valid_593989 = path.getOrDefault("subscriptionId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "subscriptionId", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
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

proc call*(call_593992: Call_CheckNameAvailabilityWithSubscription_593972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_CheckNameAvailabilityWithSubscription_593972;
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
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  var body_593996 = newJObject()
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  if checkNameAvailabilityInput != nil:
    body_593996 = checkNameAvailabilityInput
  result = call_593993.call(path_593994, query_593995, nil, nil, body_593996)

var checkNameAvailabilityWithSubscription* = Call_CheckNameAvailabilityWithSubscription_593972(
    name: "checkNameAvailabilityWithSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_CheckNameAvailabilityWithSubscription_593973, base: "",
    url: url_CheckNameAvailabilityWithSubscription_593974, schemes: {Scheme.Https})
type
  Call_ResourceUsageList_593997 = ref object of OpenApiRestCall_593438
proc url_ResourceUsageList_593999(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceUsageList_593998(path: JsonNode; query: JsonNode;
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
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_ResourceUsageList_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_ResourceUsageList_593997; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceUsageList
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var resourceUsageList* = Call_ResourceUsageList_593997(name: "resourceUsageList",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/checkResourceUsage",
    validator: validate_ResourceUsageList_593998, base: "",
    url: url_ResourceUsageList_593999, schemes: {Scheme.Https})
type
  Call_ProfilesList_594006 = ref object of OpenApiRestCall_593438
proc url_ProfilesList_594008(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesList_594007(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_ProfilesList_594006; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within an Azure subscription.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_ProfilesList_594006; apiVersion: string;
          subscriptionId: string): Recallable =
  ## profilesList
  ## Lists all of the CDN profiles within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var profilesList* = Call_ProfilesList_594006(name: "profilesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesList_594007, base: "", url: url_ProfilesList_594008,
    schemes: {Scheme.Https})
type
  Call_ValidateProbe_594015 = ref object of OpenApiRestCall_593438
proc url_ValidateProbe_594017(protocol: Scheme; host: string; base: string;
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

proc validate_ValidateProbe_594016(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "api-version", valid_594019
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

proc call*(call_594021: Call_ValidateProbe_594015; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_ValidateProbe_594015; apiVersion: string;
          subscriptionId: string; validateProbeInput: JsonNode): Recallable =
  ## validateProbe
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   validateProbeInput: JObject (required)
  ##                     : Input to check.
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  var body_594025 = newJObject()
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  if validateProbeInput != nil:
    body_594025 = validateProbeInput
  result = call_594022.call(path_594023, query_594024, nil, nil, body_594025)

var validateProbe* = Call_ValidateProbe_594015(name: "validateProbe",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/validateProbe",
    validator: validate_ValidateProbe_594016, base: "", url: url_ValidateProbe_594017,
    schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_594026 = ref object of OpenApiRestCall_593438
proc url_ProfilesListByResourceGroup_594028(protocol: Scheme; host: string;
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

proc validate_ProfilesListByResourceGroup_594027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594029 = path.getOrDefault("resourceGroupName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceGroupName", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_ProfilesListByResourceGroup_594026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_ProfilesListByResourceGroup_594026;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListByResourceGroup
  ## Lists all of the CDN profiles within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(path_594034, "resourceGroupName", newJString(resourceGroupName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_594026(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListByResourceGroup_594027, base: "",
    url: url_ProfilesListByResourceGroup_594028, schemes: {Scheme.Https})
type
  Call_ProfilesCreate_594047 = ref object of OpenApiRestCall_593438
proc url_ProfilesCreate_594049(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesCreate_594048(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  var valid_594052 = path.getOrDefault("profileName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "profileName", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
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

proc call*(call_594055: Call_ProfilesCreate_594047; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_ProfilesCreate_594047; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          profile: JsonNode): Recallable =
  ## profilesCreate
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   profile: JObject (required)
  ##          : Profile properties needed to create a new profile.
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  add(path_594057, "profileName", newJString(profileName))
  if profile != nil:
    body_594059 = profile
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var profilesCreate* = Call_ProfilesCreate_594047(name: "profilesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesCreate_594048, base: "", url: url_ProfilesCreate_594049,
    schemes: {Scheme.Https})
type
  Call_ProfilesGet_594036 = ref object of OpenApiRestCall_593438
proc url_ProfilesGet_594038(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGet_594037(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("subscriptionId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "subscriptionId", valid_594040
  var valid_594041 = path.getOrDefault("profileName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "profileName", valid_594041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594042 = query.getOrDefault("api-version")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "api-version", valid_594042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_ProfilesGet_594036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_ProfilesGet_594036; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesGet
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  add(path_594045, "resourceGroupName", newJString(resourceGroupName))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  add(path_594045, "profileName", newJString(profileName))
  result = call_594044.call(path_594045, query_594046, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_594036(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
                                        validator: validate_ProfilesGet_594037,
                                        base: "", url: url_ProfilesGet_594038,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_594071 = ref object of OpenApiRestCall_593438
proc url_ProfilesUpdate_594073(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesUpdate_594072(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("profileName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "profileName", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "api-version", valid_594077
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

proc call*(call_594079: Call_ProfilesUpdate_594071; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_ProfilesUpdate_594071; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          profileUpdateParameters: JsonNode): Recallable =
  ## profilesUpdate
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   profileUpdateParameters: JObject (required)
  ##                          : Profile properties needed to update an existing profile.
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  var body_594083 = newJObject()
  add(path_594081, "resourceGroupName", newJString(resourceGroupName))
  add(query_594082, "api-version", newJString(apiVersion))
  add(path_594081, "subscriptionId", newJString(subscriptionId))
  add(path_594081, "profileName", newJString(profileName))
  if profileUpdateParameters != nil:
    body_594083 = profileUpdateParameters
  result = call_594080.call(path_594081, query_594082, nil, nil, body_594083)

var profilesUpdate* = Call_ProfilesUpdate_594071(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesUpdate_594072, base: "", url: url_ProfilesUpdate_594073,
    schemes: {Scheme.Https})
type
  Call_ProfilesDelete_594060 = ref object of OpenApiRestCall_593438
proc url_ProfilesDelete_594062(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesDelete_594061(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  var valid_594065 = path.getOrDefault("profileName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "profileName", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "api-version", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_ProfilesDelete_594060; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_ProfilesDelete_594060; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesDelete
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  add(path_594069, "profileName", newJString(profileName))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_594060(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesDelete_594061, base: "", url: url_ProfilesDelete_594062,
    schemes: {Scheme.Https})
type
  Call_ProfilesListResourceUsage_594084 = ref object of OpenApiRestCall_593438
proc url_ProfilesListResourceUsage_594086(protocol: Scheme; host: string;
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

proc validate_ProfilesListResourceUsage_594085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594087 = path.getOrDefault("resourceGroupName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "resourceGroupName", valid_594087
  var valid_594088 = path.getOrDefault("subscriptionId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "subscriptionId", valid_594088
  var valid_594089 = path.getOrDefault("profileName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "profileName", valid_594089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594090 = query.getOrDefault("api-version")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "api-version", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_ProfilesListResourceUsage_594084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_ProfilesListResourceUsage_594084;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesListResourceUsage
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(path_594093, "resourceGroupName", newJString(resourceGroupName))
  add(query_594094, "api-version", newJString(apiVersion))
  add(path_594093, "subscriptionId", newJString(subscriptionId))
  add(path_594093, "profileName", newJString(profileName))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var profilesListResourceUsage* = Call_ProfilesListResourceUsage_594084(
    name: "profilesListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/checkResourceUsage",
    validator: validate_ProfilesListResourceUsage_594085, base: "",
    url: url_ProfilesListResourceUsage_594086, schemes: {Scheme.Https})
type
  Call_EndpointsListByProfile_594095 = ref object of OpenApiRestCall_593438
proc url_EndpointsListByProfile_594097(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsListByProfile_594096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists existing CDN endpoints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594098 = path.getOrDefault("resourceGroupName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceGroupName", valid_594098
  var valid_594099 = path.getOrDefault("subscriptionId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "subscriptionId", valid_594099
  var valid_594100 = path.getOrDefault("profileName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "profileName", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "api-version", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_EndpointsListByProfile_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing CDN endpoints.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_EndpointsListByProfile_594095;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## endpointsListByProfile
  ## Lists existing CDN endpoints.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(path_594104, "profileName", newJString(profileName))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var endpointsListByProfile* = Call_EndpointsListByProfile_594095(
    name: "endpointsListByProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints",
    validator: validate_EndpointsListByProfile_594096, base: "",
    url: url_EndpointsListByProfile_594097, schemes: {Scheme.Https})
type
  Call_EndpointsCreate_594118 = ref object of OpenApiRestCall_593438
proc url_EndpointsCreate_594120(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsCreate_594119(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594121 = path.getOrDefault("resourceGroupName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "resourceGroupName", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  var valid_594123 = path.getOrDefault("profileName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "profileName", valid_594123
  var valid_594124 = path.getOrDefault("endpointName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "endpointName", valid_594124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594125 = query.getOrDefault("api-version")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "api-version", valid_594125
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

proc call*(call_594127: Call_EndpointsCreate_594118; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_EndpointsCreate_594118; resourceGroupName: string;
          apiVersion: string; endpoint: JsonNode; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsCreate
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   endpoint: JObject (required)
  ##           : Endpoint properties
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  var body_594131 = newJObject()
  add(path_594129, "resourceGroupName", newJString(resourceGroupName))
  add(query_594130, "api-version", newJString(apiVersion))
  if endpoint != nil:
    body_594131 = endpoint
  add(path_594129, "subscriptionId", newJString(subscriptionId))
  add(path_594129, "profileName", newJString(profileName))
  add(path_594129, "endpointName", newJString(endpointName))
  result = call_594128.call(path_594129, query_594130, nil, nil, body_594131)

var endpointsCreate* = Call_EndpointsCreate_594118(name: "endpointsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsCreate_594119, base: "", url: url_EndpointsCreate_594120,
    schemes: {Scheme.Https})
type
  Call_EndpointsGet_594106 = ref object of OpenApiRestCall_593438
proc url_EndpointsGet_594108(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsGet_594107(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("profileName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "profileName", valid_594111
  var valid_594112 = path.getOrDefault("endpointName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "endpointName", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_EndpointsGet_594106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_EndpointsGet_594106; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsGet
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(path_594116, "resourceGroupName", newJString(resourceGroupName))
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "subscriptionId", newJString(subscriptionId))
  add(path_594116, "profileName", newJString(profileName))
  add(path_594116, "endpointName", newJString(endpointName))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_594106(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsGet_594107, base: "", url: url_EndpointsGet_594108,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_594144 = ref object of OpenApiRestCall_593438
proc url_EndpointsUpdate_594146(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsUpdate_594145(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594147 = path.getOrDefault("resourceGroupName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "resourceGroupName", valid_594147
  var valid_594148 = path.getOrDefault("subscriptionId")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "subscriptionId", valid_594148
  var valid_594149 = path.getOrDefault("profileName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "profileName", valid_594149
  var valid_594150 = path.getOrDefault("endpointName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "endpointName", valid_594150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594151 = query.getOrDefault("api-version")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "api-version", valid_594151
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

proc call*(call_594153: Call_EndpointsUpdate_594144; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_EndpointsUpdate_594144; resourceGroupName: string;
          endpointUpdateProperties: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsUpdate
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointUpdateProperties: JObject (required)
  ##                           : Endpoint update properties
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  var body_594157 = newJObject()
  add(path_594155, "resourceGroupName", newJString(resourceGroupName))
  if endpointUpdateProperties != nil:
    body_594157 = endpointUpdateProperties
  add(query_594156, "api-version", newJString(apiVersion))
  add(path_594155, "subscriptionId", newJString(subscriptionId))
  add(path_594155, "profileName", newJString(profileName))
  add(path_594155, "endpointName", newJString(endpointName))
  result = call_594154.call(path_594155, query_594156, nil, nil, body_594157)

var endpointsUpdate* = Call_EndpointsUpdate_594144(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsUpdate_594145, base: "", url: url_EndpointsUpdate_594146,
    schemes: {Scheme.Https})
type
  Call_EndpointsDelete_594132 = ref object of OpenApiRestCall_593438
proc url_EndpointsDelete_594134(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsDelete_594133(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594135 = path.getOrDefault("resourceGroupName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "resourceGroupName", valid_594135
  var valid_594136 = path.getOrDefault("subscriptionId")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "subscriptionId", valid_594136
  var valid_594137 = path.getOrDefault("profileName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "profileName", valid_594137
  var valid_594138 = path.getOrDefault("endpointName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "endpointName", valid_594138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594139 = query.getOrDefault("api-version")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "api-version", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_EndpointsDelete_594132; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_EndpointsDelete_594132; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsDelete
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(path_594142, "resourceGroupName", newJString(resourceGroupName))
  add(query_594143, "api-version", newJString(apiVersion))
  add(path_594142, "subscriptionId", newJString(subscriptionId))
  add(path_594142, "profileName", newJString(profileName))
  add(path_594142, "endpointName", newJString(endpointName))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var endpointsDelete* = Call_EndpointsDelete_594132(name: "endpointsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsDelete_594133, base: "", url: url_EndpointsDelete_594134,
    schemes: {Scheme.Https})
type
  Call_EndpointsListResourceUsage_594158 = ref object of OpenApiRestCall_593438
proc url_EndpointsListResourceUsage_594160(protocol: Scheme; host: string;
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

proc validate_EndpointsListResourceUsage_594159(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("subscriptionId")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "subscriptionId", valid_594162
  var valid_594163 = path.getOrDefault("profileName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "profileName", valid_594163
  var valid_594164 = path.getOrDefault("endpointName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "endpointName", valid_594164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594165 = query.getOrDefault("api-version")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "api-version", valid_594165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_EndpointsListResourceUsage_594158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_EndpointsListResourceUsage_594158;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsListResourceUsage
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  add(path_594168, "profileName", newJString(profileName))
  add(path_594168, "endpointName", newJString(endpointName))
  result = call_594167.call(path_594168, query_594169, nil, nil, nil)

var endpointsListResourceUsage* = Call_EndpointsListResourceUsage_594158(
    name: "endpointsListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/checkResourceUsage",
    validator: validate_EndpointsListResourceUsage_594159, base: "",
    url: url_EndpointsListResourceUsage_594160, schemes: {Scheme.Https})
type
  Call_CustomDomainsListByEndpoint_594170 = ref object of OpenApiRestCall_593438
proc url_CustomDomainsListByEndpoint_594172(protocol: Scheme; host: string;
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

proc validate_CustomDomainsListByEndpoint_594171(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594173 = path.getOrDefault("resourceGroupName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "resourceGroupName", valid_594173
  var valid_594174 = path.getOrDefault("subscriptionId")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "subscriptionId", valid_594174
  var valid_594175 = path.getOrDefault("profileName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "profileName", valid_594175
  var valid_594176 = path.getOrDefault("endpointName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "endpointName", valid_594176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594177 = query.getOrDefault("api-version")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "api-version", valid_594177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594178: Call_CustomDomainsListByEndpoint_594170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_CustomDomainsListByEndpoint_594170;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsListByEndpoint
  ## Lists all of the existing custom domains within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594180 = newJObject()
  var query_594181 = newJObject()
  add(path_594180, "resourceGroupName", newJString(resourceGroupName))
  add(query_594181, "api-version", newJString(apiVersion))
  add(path_594180, "subscriptionId", newJString(subscriptionId))
  add(path_594180, "profileName", newJString(profileName))
  add(path_594180, "endpointName", newJString(endpointName))
  result = call_594179.call(path_594180, query_594181, nil, nil, nil)

var customDomainsListByEndpoint* = Call_CustomDomainsListByEndpoint_594170(
    name: "customDomainsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains",
    validator: validate_CustomDomainsListByEndpoint_594171, base: "",
    url: url_CustomDomainsListByEndpoint_594172, schemes: {Scheme.Https})
type
  Call_CustomDomainsCreate_594195 = ref object of OpenApiRestCall_593438
proc url_CustomDomainsCreate_594197(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsCreate_594196(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594198 = path.getOrDefault("resourceGroupName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "resourceGroupName", valid_594198
  var valid_594199 = path.getOrDefault("subscriptionId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "subscriptionId", valid_594199
  var valid_594200 = path.getOrDefault("customDomainName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "customDomainName", valid_594200
  var valid_594201 = path.getOrDefault("profileName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "profileName", valid_594201
  var valid_594202 = path.getOrDefault("endpointName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "endpointName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
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

proc call*(call_594205: Call_CustomDomainsCreate_594195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new custom domain within an endpoint.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_CustomDomainsCreate_594195; resourceGroupName: string;
          apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; customDomainName: string; profileName: string;
          endpointName: string): Recallable =
  ## customDomainsCreate
  ## Creates a new custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   customDomainProperties: JObject (required)
  ##                         : Properties required to create a new custom domain.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  var body_594209 = newJObject()
  add(path_594207, "resourceGroupName", newJString(resourceGroupName))
  add(query_594208, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_594209 = customDomainProperties
  add(path_594207, "subscriptionId", newJString(subscriptionId))
  add(path_594207, "customDomainName", newJString(customDomainName))
  add(path_594207, "profileName", newJString(profileName))
  add(path_594207, "endpointName", newJString(endpointName))
  result = call_594206.call(path_594207, query_594208, nil, nil, body_594209)

var customDomainsCreate* = Call_CustomDomainsCreate_594195(
    name: "customDomainsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsCreate_594196, base: "",
    url: url_CustomDomainsCreate_594197, schemes: {Scheme.Https})
type
  Call_CustomDomainsGet_594182 = ref object of OpenApiRestCall_593438
proc url_CustomDomainsGet_594184(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsGet_594183(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets an existing custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594185 = path.getOrDefault("resourceGroupName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "resourceGroupName", valid_594185
  var valid_594186 = path.getOrDefault("subscriptionId")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "subscriptionId", valid_594186
  var valid_594187 = path.getOrDefault("customDomainName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "customDomainName", valid_594187
  var valid_594188 = path.getOrDefault("profileName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "profileName", valid_594188
  var valid_594189 = path.getOrDefault("endpointName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "endpointName", valid_594189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594190 = query.getOrDefault("api-version")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "api-version", valid_594190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594191: Call_CustomDomainsGet_594182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing custom domain within an endpoint.
  ## 
  let valid = call_594191.validator(path, query, header, formData, body)
  let scheme = call_594191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594191.url(scheme.get, call_594191.host, call_594191.base,
                         call_594191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594191, url, valid)

proc call*(call_594192: Call_CustomDomainsGet_594182; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; customDomainName: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsGet
  ## Gets an existing custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594193 = newJObject()
  var query_594194 = newJObject()
  add(path_594193, "resourceGroupName", newJString(resourceGroupName))
  add(query_594194, "api-version", newJString(apiVersion))
  add(path_594193, "subscriptionId", newJString(subscriptionId))
  add(path_594193, "customDomainName", newJString(customDomainName))
  add(path_594193, "profileName", newJString(profileName))
  add(path_594193, "endpointName", newJString(endpointName))
  result = call_594192.call(path_594193, query_594194, nil, nil, nil)

var customDomainsGet* = Call_CustomDomainsGet_594182(name: "customDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsGet_594183, base: "",
    url: url_CustomDomainsGet_594184, schemes: {Scheme.Https})
type
  Call_CustomDomainsDelete_594210 = ref object of OpenApiRestCall_593438
proc url_CustomDomainsDelete_594212(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsDelete_594211(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594213 = path.getOrDefault("resourceGroupName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "resourceGroupName", valid_594213
  var valid_594214 = path.getOrDefault("subscriptionId")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "subscriptionId", valid_594214
  var valid_594215 = path.getOrDefault("customDomainName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "customDomainName", valid_594215
  var valid_594216 = path.getOrDefault("profileName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "profileName", valid_594216
  var valid_594217 = path.getOrDefault("endpointName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "endpointName", valid_594217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594218 = query.getOrDefault("api-version")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "api-version", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_CustomDomainsDelete_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_CustomDomainsDelete_594210; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; customDomainName: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsDelete
  ## Deletes an existing custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(path_594221, "resourceGroupName", newJString(resourceGroupName))
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "subscriptionId", newJString(subscriptionId))
  add(path_594221, "customDomainName", newJString(customDomainName))
  add(path_594221, "profileName", newJString(profileName))
  add(path_594221, "endpointName", newJString(endpointName))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var customDomainsDelete* = Call_CustomDomainsDelete_594210(
    name: "customDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsDelete_594211, base: "",
    url: url_CustomDomainsDelete_594212, schemes: {Scheme.Https})
type
  Call_CustomDomainsDisableCustomHttps_594223 = ref object of OpenApiRestCall_593438
proc url_CustomDomainsDisableCustomHttps_594225(protocol: Scheme; host: string;
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

proc validate_CustomDomainsDisableCustomHttps_594224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable https delivery of the custom domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594226 = path.getOrDefault("resourceGroupName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "resourceGroupName", valid_594226
  var valid_594227 = path.getOrDefault("subscriptionId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "subscriptionId", valid_594227
  var valid_594228 = path.getOrDefault("customDomainName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "customDomainName", valid_594228
  var valid_594229 = path.getOrDefault("profileName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "profileName", valid_594229
  var valid_594230 = path.getOrDefault("endpointName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "endpointName", valid_594230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594231 = query.getOrDefault("api-version")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "api-version", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_CustomDomainsDisableCustomHttps_594223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable https delivery of the custom domain.
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_CustomDomainsDisableCustomHttps_594223;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          customDomainName: string; profileName: string; endpointName: string): Recallable =
  ## customDomainsDisableCustomHttps
  ## Disable https delivery of the custom domain.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  add(path_594234, "customDomainName", newJString(customDomainName))
  add(path_594234, "profileName", newJString(profileName))
  add(path_594234, "endpointName", newJString(endpointName))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var customDomainsDisableCustomHttps* = Call_CustomDomainsDisableCustomHttps_594223(
    name: "customDomainsDisableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/disableCustomHttps",
    validator: validate_CustomDomainsDisableCustomHttps_594224, base: "",
    url: url_CustomDomainsDisableCustomHttps_594225, schemes: {Scheme.Https})
type
  Call_CustomDomainsEnableCustomHttps_594236 = ref object of OpenApiRestCall_593438
proc url_CustomDomainsEnableCustomHttps_594238(protocol: Scheme; host: string;
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

proc validate_CustomDomainsEnableCustomHttps_594237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable https delivery of the custom domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594256 = path.getOrDefault("resourceGroupName")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "resourceGroupName", valid_594256
  var valid_594257 = path.getOrDefault("subscriptionId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "subscriptionId", valid_594257
  var valid_594258 = path.getOrDefault("customDomainName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "customDomainName", valid_594258
  var valid_594259 = path.getOrDefault("profileName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "profileName", valid_594259
  var valid_594260 = path.getOrDefault("endpointName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "endpointName", valid_594260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594261 = query.getOrDefault("api-version")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "api-version", valid_594261
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

proc call*(call_594263: Call_CustomDomainsEnableCustomHttps_594236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable https delivery of the custom domain.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_CustomDomainsEnableCustomHttps_594236;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          customDomainName: string; profileName: string; endpointName: string;
          customDomainHttpsParameters: JsonNode = nil): Recallable =
  ## customDomainsEnableCustomHttps
  ## Enable https delivery of the custom domain.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   customDomainHttpsParameters: JObject
  ##                              : The configuration specifying how to enable HTTPS for the custom domain - using CDN managed certificate or user's own certificate. If not specified, enabling ssl uses CDN managed certificate by default.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  var body_594267 = newJObject()
  add(path_594265, "resourceGroupName", newJString(resourceGroupName))
  add(query_594266, "api-version", newJString(apiVersion))
  add(path_594265, "subscriptionId", newJString(subscriptionId))
  add(path_594265, "customDomainName", newJString(customDomainName))
  add(path_594265, "profileName", newJString(profileName))
  if customDomainHttpsParameters != nil:
    body_594267 = customDomainHttpsParameters
  add(path_594265, "endpointName", newJString(endpointName))
  result = call_594264.call(path_594265, query_594266, nil, nil, body_594267)

var customDomainsEnableCustomHttps* = Call_CustomDomainsEnableCustomHttps_594236(
    name: "customDomainsEnableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/enableCustomHttps",
    validator: validate_CustomDomainsEnableCustomHttps_594237, base: "",
    url: url_CustomDomainsEnableCustomHttps_594238, schemes: {Scheme.Https})
type
  Call_EndpointsLoadContent_594268 = ref object of OpenApiRestCall_593438
proc url_EndpointsLoadContent_594270(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsLoadContent_594269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594271 = path.getOrDefault("resourceGroupName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "resourceGroupName", valid_594271
  var valid_594272 = path.getOrDefault("subscriptionId")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "subscriptionId", valid_594272
  var valid_594273 = path.getOrDefault("profileName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "profileName", valid_594273
  var valid_594274 = path.getOrDefault("endpointName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "endpointName", valid_594274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594275 = query.getOrDefault("api-version")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "api-version", valid_594275
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

proc call*(call_594277: Call_EndpointsLoadContent_594268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_EndpointsLoadContent_594268;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsLoadContent
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should be a full URL, e.g. ‘/pictures/city.png' which loads a single file 
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  var body_594281 = newJObject()
  add(path_594279, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_594281 = contentFilePaths
  add(query_594280, "api-version", newJString(apiVersion))
  add(path_594279, "subscriptionId", newJString(subscriptionId))
  add(path_594279, "profileName", newJString(profileName))
  add(path_594279, "endpointName", newJString(endpointName))
  result = call_594278.call(path_594279, query_594280, nil, nil, body_594281)

var endpointsLoadContent* = Call_EndpointsLoadContent_594268(
    name: "endpointsLoadContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/load",
    validator: validate_EndpointsLoadContent_594269, base: "",
    url: url_EndpointsLoadContent_594270, schemes: {Scheme.Https})
type
  Call_OriginsListByEndpoint_594282 = ref object of OpenApiRestCall_593438
proc url_OriginsListByEndpoint_594284(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsListByEndpoint_594283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the existing origins within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594285 = path.getOrDefault("resourceGroupName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "resourceGroupName", valid_594285
  var valid_594286 = path.getOrDefault("subscriptionId")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "subscriptionId", valid_594286
  var valid_594287 = path.getOrDefault("profileName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "profileName", valid_594287
  var valid_594288 = path.getOrDefault("endpointName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "endpointName", valid_594288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594289 = query.getOrDefault("api-version")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "api-version", valid_594289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594290: Call_OriginsListByEndpoint_594282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing origins within an endpoint.
  ## 
  let valid = call_594290.validator(path, query, header, formData, body)
  let scheme = call_594290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594290.url(scheme.get, call_594290.host, call_594290.base,
                         call_594290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594290, url, valid)

proc call*(call_594291: Call_OriginsListByEndpoint_594282;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsListByEndpoint
  ## Lists all of the existing origins within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594292 = newJObject()
  var query_594293 = newJObject()
  add(path_594292, "resourceGroupName", newJString(resourceGroupName))
  add(query_594293, "api-version", newJString(apiVersion))
  add(path_594292, "subscriptionId", newJString(subscriptionId))
  add(path_594292, "profileName", newJString(profileName))
  add(path_594292, "endpointName", newJString(endpointName))
  result = call_594291.call(path_594292, query_594293, nil, nil, nil)

var originsListByEndpoint* = Call_OriginsListByEndpoint_594282(
    name: "originsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins",
    validator: validate_OriginsListByEndpoint_594283, base: "",
    url: url_OriginsListByEndpoint_594284, schemes: {Scheme.Https})
type
  Call_OriginsGet_594294 = ref object of OpenApiRestCall_593438
proc url_OriginsGet_594296(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OriginsGet_594295(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing origin within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594297 = path.getOrDefault("resourceGroupName")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "resourceGroupName", valid_594297
  var valid_594298 = path.getOrDefault("originName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "originName", valid_594298
  var valid_594299 = path.getOrDefault("subscriptionId")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "subscriptionId", valid_594299
  var valid_594300 = path.getOrDefault("profileName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "profileName", valid_594300
  var valid_594301 = path.getOrDefault("endpointName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "endpointName", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_OriginsGet_594294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing origin within an endpoint.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_OriginsGet_594294; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsGet
  ## Gets an existing origin within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   originName: string (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  add(path_594305, "resourceGroupName", newJString(resourceGroupName))
  add(query_594306, "api-version", newJString(apiVersion))
  add(path_594305, "originName", newJString(originName))
  add(path_594305, "subscriptionId", newJString(subscriptionId))
  add(path_594305, "profileName", newJString(profileName))
  add(path_594305, "endpointName", newJString(endpointName))
  result = call_594304.call(path_594305, query_594306, nil, nil, nil)

var originsGet* = Call_OriginsGet_594294(name: "originsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
                                      validator: validate_OriginsGet_594295,
                                      base: "", url: url_OriginsGet_594296,
                                      schemes: {Scheme.Https})
type
  Call_OriginsUpdate_594307 = ref object of OpenApiRestCall_593438
proc url_OriginsUpdate_594309(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsUpdate_594308(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing origin within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594310 = path.getOrDefault("resourceGroupName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "resourceGroupName", valid_594310
  var valid_594311 = path.getOrDefault("originName")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "originName", valid_594311
  var valid_594312 = path.getOrDefault("subscriptionId")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "subscriptionId", valid_594312
  var valid_594313 = path.getOrDefault("profileName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "profileName", valid_594313
  var valid_594314 = path.getOrDefault("endpointName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "endpointName", valid_594314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594315 = query.getOrDefault("api-version")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "api-version", valid_594315
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

proc call*(call_594317: Call_OriginsUpdate_594307; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing origin within an endpoint.
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_OriginsUpdate_594307;
          originUpdateProperties: JsonNode; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsUpdate
  ## Updates an existing origin within an endpoint.
  ##   originUpdateProperties: JObject (required)
  ##                         : Origin properties
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   originName: string (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  var body_594321 = newJObject()
  if originUpdateProperties != nil:
    body_594321 = originUpdateProperties
  add(path_594319, "resourceGroupName", newJString(resourceGroupName))
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "originName", newJString(originName))
  add(path_594319, "subscriptionId", newJString(subscriptionId))
  add(path_594319, "profileName", newJString(profileName))
  add(path_594319, "endpointName", newJString(endpointName))
  result = call_594318.call(path_594319, query_594320, nil, nil, body_594321)

var originsUpdate* = Call_OriginsUpdate_594307(name: "originsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsUpdate_594308, base: "", url: url_OriginsUpdate_594309,
    schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_594322 = ref object of OpenApiRestCall_593438
proc url_EndpointsPurgeContent_594324(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsPurgeContent_594323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a content from CDN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594325 = path.getOrDefault("resourceGroupName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "resourceGroupName", valid_594325
  var valid_594326 = path.getOrDefault("subscriptionId")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "subscriptionId", valid_594326
  var valid_594327 = path.getOrDefault("profileName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "profileName", valid_594327
  var valid_594328 = path.getOrDefault("endpointName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "endpointName", valid_594328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594329 = query.getOrDefault("api-version")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "api-version", valid_594329
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

proc call*(call_594331: Call_EndpointsPurgeContent_594322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a content from CDN.
  ## 
  let valid = call_594331.validator(path, query, header, formData, body)
  let scheme = call_594331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594331.url(scheme.get, call_594331.host, call_594331.base,
                         call_594331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594331, url, valid)

proc call*(call_594332: Call_EndpointsPurgeContent_594322;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsPurgeContent
  ## Removes a content from CDN.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594333 = newJObject()
  var query_594334 = newJObject()
  var body_594335 = newJObject()
  add(path_594333, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_594335 = contentFilePaths
  add(query_594334, "api-version", newJString(apiVersion))
  add(path_594333, "subscriptionId", newJString(subscriptionId))
  add(path_594333, "profileName", newJString(profileName))
  add(path_594333, "endpointName", newJString(endpointName))
  result = call_594332.call(path_594333, query_594334, nil, nil, body_594335)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_594322(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/purge",
    validator: validate_EndpointsPurgeContent_594323, base: "",
    url: url_EndpointsPurgeContent_594324, schemes: {Scheme.Https})
type
  Call_EndpointsStart_594336 = ref object of OpenApiRestCall_593438
proc url_EndpointsStart_594338(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsStart_594337(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594339 = path.getOrDefault("resourceGroupName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "resourceGroupName", valid_594339
  var valid_594340 = path.getOrDefault("subscriptionId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "subscriptionId", valid_594340
  var valid_594341 = path.getOrDefault("profileName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "profileName", valid_594341
  var valid_594342 = path.getOrDefault("endpointName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "endpointName", valid_594342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594343 = query.getOrDefault("api-version")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "api-version", valid_594343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594344: Call_EndpointsStart_594336; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  let valid = call_594344.validator(path, query, header, formData, body)
  let scheme = call_594344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594344.url(scheme.get, call_594344.host, call_594344.base,
                         call_594344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594344, url, valid)

proc call*(call_594345: Call_EndpointsStart_594336; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsStart
  ## Starts an existing CDN endpoint that is on a stopped state.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594346 = newJObject()
  var query_594347 = newJObject()
  add(path_594346, "resourceGroupName", newJString(resourceGroupName))
  add(query_594347, "api-version", newJString(apiVersion))
  add(path_594346, "subscriptionId", newJString(subscriptionId))
  add(path_594346, "profileName", newJString(profileName))
  add(path_594346, "endpointName", newJString(endpointName))
  result = call_594345.call(path_594346, query_594347, nil, nil, nil)

var endpointsStart* = Call_EndpointsStart_594336(name: "endpointsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/start",
    validator: validate_EndpointsStart_594337, base: "", url: url_EndpointsStart_594338,
    schemes: {Scheme.Https})
type
  Call_EndpointsStop_594348 = ref object of OpenApiRestCall_593438
proc url_EndpointsStop_594350(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsStop_594349(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an existing running CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594351 = path.getOrDefault("resourceGroupName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "resourceGroupName", valid_594351
  var valid_594352 = path.getOrDefault("subscriptionId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "subscriptionId", valid_594352
  var valid_594353 = path.getOrDefault("profileName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "profileName", valid_594353
  var valid_594354 = path.getOrDefault("endpointName")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "endpointName", valid_594354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594355 = query.getOrDefault("api-version")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "api-version", valid_594355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594356: Call_EndpointsStop_594348; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing running CDN endpoint.
  ## 
  let valid = call_594356.validator(path, query, header, formData, body)
  let scheme = call_594356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594356.url(scheme.get, call_594356.host, call_594356.base,
                         call_594356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594356, url, valid)

proc call*(call_594357: Call_EndpointsStop_594348; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsStop
  ## Stops an existing running CDN endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594358 = newJObject()
  var query_594359 = newJObject()
  add(path_594358, "resourceGroupName", newJString(resourceGroupName))
  add(query_594359, "api-version", newJString(apiVersion))
  add(path_594358, "subscriptionId", newJString(subscriptionId))
  add(path_594358, "profileName", newJString(profileName))
  add(path_594358, "endpointName", newJString(endpointName))
  result = call_594357.call(path_594358, query_594359, nil, nil, nil)

var endpointsStop* = Call_EndpointsStop_594348(name: "endpointsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/stop",
    validator: validate_EndpointsStop_594349, base: "", url: url_EndpointsStop_594350,
    schemes: {Scheme.Https})
type
  Call_EndpointsValidateCustomDomain_594360 = ref object of OpenApiRestCall_593438
proc url_EndpointsValidateCustomDomain_594362(protocol: Scheme; host: string;
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

proc validate_EndpointsValidateCustomDomain_594361(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594363 = path.getOrDefault("resourceGroupName")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "resourceGroupName", valid_594363
  var valid_594364 = path.getOrDefault("subscriptionId")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "subscriptionId", valid_594364
  var valid_594365 = path.getOrDefault("profileName")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "profileName", valid_594365
  var valid_594366 = path.getOrDefault("endpointName")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "endpointName", valid_594366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594367 = query.getOrDefault("api-version")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "api-version", valid_594367
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

proc call*(call_594369: Call_EndpointsValidateCustomDomain_594360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  let valid = call_594369.validator(path, query, header, formData, body)
  let scheme = call_594369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594369.url(scheme.get, call_594369.host, call_594369.base,
                         call_594369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594369, url, valid)

proc call*(call_594370: Call_EndpointsValidateCustomDomain_594360;
          resourceGroupName: string; apiVersion: string;
          customDomainProperties: JsonNode; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsValidateCustomDomain
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_594371 = newJObject()
  var query_594372 = newJObject()
  var body_594373 = newJObject()
  add(path_594371, "resourceGroupName", newJString(resourceGroupName))
  add(query_594372, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_594373 = customDomainProperties
  add(path_594371, "subscriptionId", newJString(subscriptionId))
  add(path_594371, "profileName", newJString(profileName))
  add(path_594371, "endpointName", newJString(endpointName))
  result = call_594370.call(path_594371, query_594372, nil, nil, body_594373)

var endpointsValidateCustomDomain* = Call_EndpointsValidateCustomDomain_594360(
    name: "endpointsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/validateCustomDomain",
    validator: validate_EndpointsValidateCustomDomain_594361, base: "",
    url: url_EndpointsValidateCustomDomain_594362, schemes: {Scheme.Https})
type
  Call_ProfilesGenerateSsoUri_594374 = ref object of OpenApiRestCall_593438
proc url_ProfilesGenerateSsoUri_594376(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGenerateSsoUri_594375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594377 = path.getOrDefault("resourceGroupName")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "resourceGroupName", valid_594377
  var valid_594378 = path.getOrDefault("subscriptionId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "subscriptionId", valid_594378
  var valid_594379 = path.getOrDefault("profileName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "profileName", valid_594379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594380 = query.getOrDefault("api-version")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "api-version", valid_594380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594381: Call_ProfilesGenerateSsoUri_594374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  let valid = call_594381.validator(path, query, header, formData, body)
  let scheme = call_594381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594381.url(scheme.get, call_594381.host, call_594381.base,
                         call_594381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594381, url, valid)

proc call*(call_594382: Call_ProfilesGenerateSsoUri_594374;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesGenerateSsoUri
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_594383 = newJObject()
  var query_594384 = newJObject()
  add(path_594383, "resourceGroupName", newJString(resourceGroupName))
  add(query_594384, "api-version", newJString(apiVersion))
  add(path_594383, "subscriptionId", newJString(subscriptionId))
  add(path_594383, "profileName", newJString(profileName))
  result = call_594382.call(path_594383, query_594384, nil, nil, nil)

var profilesGenerateSsoUri* = Call_ProfilesGenerateSsoUri_594374(
    name: "profilesGenerateSsoUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/generateSsoUri",
    validator: validate_ProfilesGenerateSsoUri_594375, base: "",
    url: url_ProfilesGenerateSsoUri_594376, schemes: {Scheme.Https})
type
  Call_ProfilesListSupportedOptimizationTypes_594385 = ref object of OpenApiRestCall_593438
proc url_ProfilesListSupportedOptimizationTypes_594387(protocol: Scheme;
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

proc validate_ProfilesListSupportedOptimizationTypes_594386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594388 = path.getOrDefault("resourceGroupName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "resourceGroupName", valid_594388
  var valid_594389 = path.getOrDefault("subscriptionId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "subscriptionId", valid_594389
  var valid_594390 = path.getOrDefault("profileName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "profileName", valid_594390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594391 = query.getOrDefault("api-version")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "api-version", valid_594391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594392: Call_ProfilesListSupportedOptimizationTypes_594385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  let valid = call_594392.validator(path, query, header, formData, body)
  let scheme = call_594392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594392.url(scheme.get, call_594392.host, call_594392.base,
                         call_594392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594392, url, valid)

proc call*(call_594393: Call_ProfilesListSupportedOptimizationTypes_594385;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesListSupportedOptimizationTypes
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_594394 = newJObject()
  var query_594395 = newJObject()
  add(path_594394, "resourceGroupName", newJString(resourceGroupName))
  add(query_594395, "api-version", newJString(apiVersion))
  add(path_594394, "subscriptionId", newJString(subscriptionId))
  add(path_594394, "profileName", newJString(profileName))
  result = call_594393.call(path_594394, query_594395, nil, nil, nil)

var profilesListSupportedOptimizationTypes* = Call_ProfilesListSupportedOptimizationTypes_594385(
    name: "profilesListSupportedOptimizationTypes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/getSupportedOptimizationTypes",
    validator: validate_ProfilesListSupportedOptimizationTypes_594386, base: "",
    url: url_ProfilesListSupportedOptimizationTypes_594387,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
