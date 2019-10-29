
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SubscriptionClient
## version: 2016-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## All resource groups and resources exist within subscriptions. These operation enable you get information about your subscriptions and tenants. A tenant is a dedicated instance of Azure Active Directory (Azure AD) for your organization.
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

  OpenApiRestCall_563540 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563540](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563540): Option[Scheme] {.used.} =
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
  macServiceName = "resources-subscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563762 = ref object of OpenApiRestCall_563540
proc url_OperationsList_563764(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563763(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563925 = query.getOrDefault("api-version")
  valid_563925 = validateParameter(valid_563925, JString, required = true,
                                 default = nil)
  if valid_563925 != nil:
    section.add "api-version", valid_563925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563948: Call_OperationsList_563762; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  let valid = call_563948.validator(path, query, header, formData, body)
  let scheme = call_563948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563948.url(scheme.get, call_563948.host, call_563948.base,
                         call_563948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563948, url, valid)

proc call*(call_564019: Call_OperationsList_563762; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Resources REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_564020 = newJObject()
  add(query_564020, "api-version", newJString(apiVersion))
  result = call_564019.call(nil, query_564020, nil, nil, nil)

var operationsList* = Call_OperationsList_563762(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Resources/operations",
    validator: validate_OperationsList_563763, base: "", url: url_OperationsList_563764,
    schemes: {Scheme.Https})
type
  Call_SubscriptionsList_564060 = ref object of OpenApiRestCall_563540
proc url_SubscriptionsList_564062(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionsList_564061(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all subscriptions for a tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564063 = query.getOrDefault("api-version")
  valid_564063 = validateParameter(valid_564063, JString, required = true,
                                 default = nil)
  if valid_564063 != nil:
    section.add "api-version", valid_564063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564064: Call_SubscriptionsList_564060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all subscriptions for a tenant.
  ## 
  let valid = call_564064.validator(path, query, header, formData, body)
  let scheme = call_564064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564064.url(scheme.get, call_564064.host, call_564064.base,
                         call_564064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564064, url, valid)

proc call*(call_564065: Call_SubscriptionsList_564060; apiVersion: string): Recallable =
  ## subscriptionsList
  ## Gets all subscriptions for a tenant.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_564066 = newJObject()
  add(query_564066, "api-version", newJString(apiVersion))
  result = call_564065.call(nil, query_564066, nil, nil, nil)

var subscriptionsList* = Call_SubscriptionsList_564060(name: "subscriptionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions",
    validator: validate_SubscriptionsList_564061, base: "",
    url: url_SubscriptionsList_564062, schemes: {Scheme.Https})
type
  Call_SubscriptionsGet_564067 = ref object of OpenApiRestCall_563540
proc url_SubscriptionsGet_564069(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsGet_564068(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets details about a specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564084 = path.getOrDefault("subscriptionId")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "subscriptionId", valid_564084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564085 = query.getOrDefault("api-version")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "api-version", valid_564085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564086: Call_SubscriptionsGet_564067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about a specified subscription.
  ## 
  let valid = call_564086.validator(path, query, header, formData, body)
  let scheme = call_564086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564086.url(scheme.get, call_564086.host, call_564086.base,
                         call_564086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564086, url, valid)

proc call*(call_564087: Call_SubscriptionsGet_564067; apiVersion: string;
          subscriptionId: string): Recallable =
  ## subscriptionsGet
  ## Gets details about a specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564088 = newJObject()
  var query_564089 = newJObject()
  add(query_564089, "api-version", newJString(apiVersion))
  add(path_564088, "subscriptionId", newJString(subscriptionId))
  result = call_564087.call(path_564088, query_564089, nil, nil, nil)

var subscriptionsGet* = Call_SubscriptionsGet_564067(name: "subscriptionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}",
    validator: validate_SubscriptionsGet_564068, base: "",
    url: url_SubscriptionsGet_564069, schemes: {Scheme.Https})
type
  Call_SubscriptionsListLocations_564090 = ref object of OpenApiRestCall_563540
proc url_SubscriptionsListLocations_564092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsListLocations_564091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation provides all the locations that are available for resource providers; however, each resource provider may support a subset of this list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_SubscriptionsListLocations_564090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation provides all the locations that are available for resource providers; however, each resource provider may support a subset of this list.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_SubscriptionsListLocations_564090; apiVersion: string;
          subscriptionId: string): Recallable =
  ## subscriptionsListLocations
  ## This operation provides all the locations that are available for resource providers; however, each resource provider may support a subset of this list.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var subscriptionsListLocations* = Call_SubscriptionsListLocations_564090(
    name: "subscriptionsListLocations", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/locations",
    validator: validate_SubscriptionsListLocations_564091, base: "",
    url: url_SubscriptionsListLocations_564092, schemes: {Scheme.Https})
type
  Call_TenantsList_564099 = ref object of OpenApiRestCall_563540
proc url_TenantsList_564101(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TenantsList_564100(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the tenants for your account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_TenantsList_564099; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the tenants for your account.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_TenantsList_564099; apiVersion: string): Recallable =
  ## tenantsList
  ## Gets the tenants for your account.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_564105 = newJObject()
  add(query_564105, "api-version", newJString(apiVersion))
  result = call_564104.call(nil, query_564105, nil, nil, nil)

var tenantsList* = Call_TenantsList_564099(name: "tenantsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com",
                                        route: "/tenants",
                                        validator: validate_TenantsList_564100,
                                        base: "", url: url_TenantsList_564101,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
