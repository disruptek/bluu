
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionClient
## version: 2018-06-01
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "resources-subscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567864 = ref object of OpenApiRestCall_567642
proc url_OperationsList_567866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567865(path: JsonNode; query: JsonNode;
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
  var valid_568025 = query.getOrDefault("api-version")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "api-version", valid_568025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568048: Call_OperationsList_567864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  let valid = call_568048.validator(path, query, header, formData, body)
  let scheme = call_568048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568048.url(scheme.get, call_568048.host, call_568048.base,
                         call_568048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568048, url, valid)

proc call*(call_568119: Call_OperationsList_567864; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Resources REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_568120 = newJObject()
  add(query_568120, "api-version", newJString(apiVersion))
  result = call_568119.call(nil, query_568120, nil, nil, nil)

var operationsList* = Call_OperationsList_567864(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Resources/operations",
    validator: validate_OperationsList_567865, base: "", url: url_OperationsList_567866,
    schemes: {Scheme.Https})
type
  Call_SubscriptionsList_568160 = ref object of OpenApiRestCall_567642
proc url_SubscriptionsList_568162(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionsList_568161(path: JsonNode; query: JsonNode;
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
  var valid_568163 = query.getOrDefault("api-version")
  valid_568163 = validateParameter(valid_568163, JString, required = true,
                                 default = nil)
  if valid_568163 != nil:
    section.add "api-version", valid_568163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568164: Call_SubscriptionsList_568160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all subscriptions for a tenant.
  ## 
  let valid = call_568164.validator(path, query, header, formData, body)
  let scheme = call_568164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568164.url(scheme.get, call_568164.host, call_568164.base,
                         call_568164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568164, url, valid)

proc call*(call_568165: Call_SubscriptionsList_568160; apiVersion: string): Recallable =
  ## subscriptionsList
  ## Gets all subscriptions for a tenant.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_568166 = newJObject()
  add(query_568166, "api-version", newJString(apiVersion))
  result = call_568165.call(nil, query_568166, nil, nil, nil)

var subscriptionsList* = Call_SubscriptionsList_568160(name: "subscriptionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions",
    validator: validate_SubscriptionsList_568161, base: "",
    url: url_SubscriptionsList_568162, schemes: {Scheme.Https})
type
  Call_SubscriptionsGet_568167 = ref object of OpenApiRestCall_567642
proc url_SubscriptionsGet_568169(protocol: Scheme; host: string; base: string;
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

proc validate_SubscriptionsGet_568168(path: JsonNode; query: JsonNode;
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
  var valid_568184 = path.getOrDefault("subscriptionId")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "subscriptionId", valid_568184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568185 = query.getOrDefault("api-version")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "api-version", valid_568185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568186: Call_SubscriptionsGet_568167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about a specified subscription.
  ## 
  let valid = call_568186.validator(path, query, header, formData, body)
  let scheme = call_568186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568186.url(scheme.get, call_568186.host, call_568186.base,
                         call_568186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568186, url, valid)

proc call*(call_568187: Call_SubscriptionsGet_568167; apiVersion: string;
          subscriptionId: string): Recallable =
  ## subscriptionsGet
  ## Gets details about a specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568188 = newJObject()
  var query_568189 = newJObject()
  add(query_568189, "api-version", newJString(apiVersion))
  add(path_568188, "subscriptionId", newJString(subscriptionId))
  result = call_568187.call(path_568188, query_568189, nil, nil, nil)

var subscriptionsGet* = Call_SubscriptionsGet_568167(name: "subscriptionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}",
    validator: validate_SubscriptionsGet_568168, base: "",
    url: url_SubscriptionsGet_568169, schemes: {Scheme.Https})
type
  Call_SubscriptionsListLocations_568190 = ref object of OpenApiRestCall_567642
proc url_SubscriptionsListLocations_568192(protocol: Scheme; host: string;
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

proc validate_SubscriptionsListLocations_568191(path: JsonNode; query: JsonNode;
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
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_SubscriptionsListLocations_568190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation provides all the locations that are available for resource providers; however, each resource provider may support a subset of this list.
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_SubscriptionsListLocations_568190; apiVersion: string;
          subscriptionId: string): Recallable =
  ## subscriptionsListLocations
  ## This operation provides all the locations that are available for resource providers; however, each resource provider may support a subset of this list.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  add(query_568198, "api-version", newJString(apiVersion))
  add(path_568197, "subscriptionId", newJString(subscriptionId))
  result = call_568196.call(path_568197, query_568198, nil, nil, nil)

var subscriptionsListLocations* = Call_SubscriptionsListLocations_568190(
    name: "subscriptionsListLocations", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/locations",
    validator: validate_SubscriptionsListLocations_568191, base: "",
    url: url_SubscriptionsListLocations_568192, schemes: {Scheme.Https})
type
  Call_TenantsList_568199 = ref object of OpenApiRestCall_567642
proc url_TenantsList_568201(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TenantsList_568200(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_TenantsList_568199; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the tenants for your account.
  ## 
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_TenantsList_568199; apiVersion: string): Recallable =
  ## tenantsList
  ## Gets the tenants for your account.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_568205 = newJObject()
  add(query_568205, "api-version", newJString(apiVersion))
  result = call_568204.call(nil, query_568205, nil, nil, nil)

var tenantsList* = Call_TenantsList_568199(name: "tenantsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com",
                                        route: "/tenants",
                                        validator: validate_TenantsList_568200,
                                        base: "", url: url_TenantsList_568201,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
