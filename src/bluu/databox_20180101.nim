
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataBoxManagementClient
## version: 2018-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "databox"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## This method gets all the operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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
  if body != nil:
    result.add "body", body

proc call*(call_563973: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the operations.
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_OperationsList_563787; apiVersion: string): Recallable =
  ## operationsList
  ## This method gets all the operations.
  ##   apiVersion: string (required)
  ##             : The API Version
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataBox/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_JobsList_564085 = ref object of OpenApiRestCall_563565
proc url_JobsList_564087(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsList_564086(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the jobs available under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  var valid_564104 = query.getOrDefault("$skipToken")
  valid_564104 = validateParameter(valid_564104, JString, required = false,
                                 default = nil)
  if valid_564104 != nil:
    section.add "$skipToken", valid_564104
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564105 = query.getOrDefault("api-version")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "api-version", valid_564105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_JobsList_564085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the jobs available under the subscription.
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_JobsList_564085; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## jobsList
  ## Lists all the jobs available under the subscription.
  ##   SkipToken: string
  ##            : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  var path_564108 = newJObject()
  var query_564109 = newJObject()
  add(query_564109, "$skipToken", newJString(SkipToken))
  add(query_564109, "api-version", newJString(apiVersion))
  add(path_564108, "subscriptionId", newJString(subscriptionId))
  result = call_564107.call(path_564108, query_564109, nil, nil, nil)

var jobsList* = Call_JobsList_564085(name: "jobsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/jobs",
                                  validator: validate_JobsList_564086, base: "",
                                  url: url_JobsList_564087,
                                  schemes: {Scheme.Https})
type
  Call_ServiceListAvailableSkus_564110 = ref object of OpenApiRestCall_563565
proc url_ServiceListAvailableSkus_564112(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/availableSkus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceListAvailableSkus_564111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method provides the list of available skus for the given subscription and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   location: JString (required)
  ##           : The location of the resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("location")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "location", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   availableSkuRequest: JObject (required)
  ##                      : Filters for showing the available skus.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ServiceListAvailableSkus_564110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method provides the list of available skus for the given subscription and location.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ServiceListAvailableSkus_564110; apiVersion: string;
          subscriptionId: string; location: string; availableSkuRequest: JsonNode): Recallable =
  ## serviceListAvailableSkus
  ## This method provides the list of available skus for the given subscription and location.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   location: string (required)
  ##           : The location of the resource
  ##   availableSkuRequest: JObject (required)
  ##                      : Filters for showing the available skus.
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  var body_564121 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(path_564119, "location", newJString(location))
  if availableSkuRequest != nil:
    body_564121 = availableSkuRequest
  result = call_564118.call(path_564119, query_564120, nil, nil, body_564121)

var serviceListAvailableSkus* = Call_ServiceListAvailableSkus_564110(
    name: "serviceListAvailableSkus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/locations/{location}/availableSkus",
    validator: validate_ServiceListAvailableSkus_564111, base: "",
    url: url_ServiceListAvailableSkus_564112, schemes: {Scheme.Https})
type
  Call_ServiceValidateAddress_564122 = ref object of OpenApiRestCall_563565
proc url_ServiceValidateAddress_564124(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/validateAddress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceValidateAddress_564123(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method validates the customer shipping address and provide alternate addresses if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   location: JString (required)
  ##           : The location of the resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("location")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "location", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "api-version", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   validateAddress: JObject (required)
  ##                  : Shipping address of the customer.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_ServiceValidateAddress_564122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method validates the customer shipping address and provide alternate addresses if any.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_ServiceValidateAddress_564122; apiVersion: string;
          subscriptionId: string; location: string; validateAddress: JsonNode): Recallable =
  ## serviceValidateAddress
  ## This method validates the customer shipping address and provide alternate addresses if any.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   location: string (required)
  ##           : The location of the resource
  ##   validateAddress: JObject (required)
  ##                  : Shipping address of the customer.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  var body_564133 = newJObject()
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "location", newJString(location))
  if validateAddress != nil:
    body_564133 = validateAddress
  result = call_564130.call(path_564131, query_564132, nil, nil, body_564133)

var serviceValidateAddress* = Call_ServiceValidateAddress_564122(
    name: "serviceValidateAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/locations/{location}/validateAddress",
    validator: validate_ServiceValidateAddress_564123, base: "",
    url: url_ServiceValidateAddress_564124, schemes: {Scheme.Https})
type
  Call_JobsListByResourceGroup_564134 = ref object of OpenApiRestCall_563565
proc url_JobsListByResourceGroup_564136(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByResourceGroup_564135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the jobs available under the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564137 = path.getOrDefault("subscriptionId")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "subscriptionId", valid_564137
  var valid_564138 = path.getOrDefault("resourceGroupName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "resourceGroupName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  var valid_564139 = query.getOrDefault("$skipToken")
  valid_564139 = validateParameter(valid_564139, JString, required = false,
                                 default = nil)
  if valid_564139 != nil:
    section.add "$skipToken", valid_564139
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_JobsListByResourceGroup_564134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the jobs available under the given resource group.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_JobsListByResourceGroup_564134; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; SkipToken: string = ""): Recallable =
  ## jobsListByResourceGroup
  ## Lists all the jobs available under the given resource group.
  ##   SkipToken: string
  ##            : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  add(query_564144, "$skipToken", newJString(SkipToken))
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "subscriptionId", newJString(subscriptionId))
  add(path_564143, "resourceGroupName", newJString(resourceGroupName))
  result = call_564142.call(path_564143, query_564144, nil, nil, nil)

var jobsListByResourceGroup* = Call_JobsListByResourceGroup_564134(
    name: "jobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs",
    validator: validate_JobsListByResourceGroup_564135, base: "",
    url: url_JobsListByResourceGroup_564136, schemes: {Scheme.Https})
type
  Call_JobsCreate_564157 = ref object of OpenApiRestCall_563565
proc url_JobsCreate_564159(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCreate_564158(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new job with the specified parameters. Existing job cannot be updated with this API and should instead be updated with the Update job API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("resourceGroupName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "resourceGroupName", valid_564161
  var valid_564162 = path.getOrDefault("jobName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "jobName", valid_564162
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564163 = query.getOrDefault("api-version")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "api-version", valid_564163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobResource: JObject (required)
  ##              : Job details from request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_JobsCreate_564157; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job with the specified parameters. Existing job cannot be updated with this API and should instead be updated with the Update job API.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_JobsCreate_564157; apiVersion: string;
          jobResource: JsonNode; subscriptionId: string; resourceGroupName: string;
          jobName: string): Recallable =
  ## jobsCreate
  ## Creates a new job with the specified parameters. Existing job cannot be updated with this API and should instead be updated with the Update job API.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   jobResource: JObject (required)
  ##              : Job details from request body.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  var body_564169 = newJObject()
  add(query_564168, "api-version", newJString(apiVersion))
  if jobResource != nil:
    body_564169 = jobResource
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  add(path_564167, "jobName", newJString(jobName))
  result = call_564166.call(path_564167, query_564168, nil, nil, body_564169)

var jobsCreate* = Call_JobsCreate_564157(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsCreate_564158,
                                      base: "", url: url_JobsCreate_564159,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_564145 = ref object of OpenApiRestCall_563565
proc url_JobsGet_564147(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_564146(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564148 = path.getOrDefault("subscriptionId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "subscriptionId", valid_564148
  var valid_564149 = path.getOrDefault("resourceGroupName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "resourceGroupName", valid_564149
  var valid_564150 = path.getOrDefault("jobName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "jobName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $expand: JString
  ##          : $expand is supported on details parameter for job, which provides details on the job stages.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  var valid_564152 = query.getOrDefault("$expand")
  valid_564152 = validateParameter(valid_564152, JString, required = false,
                                 default = nil)
  if valid_564152 != nil:
    section.add "$expand", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_JobsGet_564145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified job.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_JobsGet_564145; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; jobName: string;
          Expand: string = ""): Recallable =
  ## jobsGet
  ## Gets information about the specified job.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   Expand: string
  ##         : $expand is supported on details parameter for job, which provides details on the job stages.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(query_564156, "api-version", newJString(apiVersion))
  add(query_564156, "$expand", newJString(Expand))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  add(path_564155, "jobName", newJString(jobName))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var jobsGet* = Call_JobsGet_564145(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                validator: validate_JobsGet_564146, base: "",
                                url: url_JobsGet_564147, schemes: {Scheme.Https})
type
  Call_JobsUpdate_564181 = ref object of OpenApiRestCall_563565
proc url_JobsUpdate_564183(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsUpdate_564182(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the properties of an existing job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  var valid_564186 = path.getOrDefault("jobName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "jobName", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The patch will be performed only if the ETag of the job on the server matches this value.
  section = newJObject()
  var valid_564188 = header.getOrDefault("If-Match")
  valid_564188 = validateParameter(valid_564188, JString, required = false,
                                 default = nil)
  if valid_564188 != nil:
    section.add "If-Match", valid_564188
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobResourceUpdateParameter: JObject (required)
  ##                             : Job update parameters from request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564190: Call_JobsUpdate_564181; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing job.
  ## 
  let valid = call_564190.validator(path, query, header, formData, body)
  let scheme = call_564190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564190.url(scheme.get, call_564190.host, call_564190.base,
                         call_564190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564190, url, valid)

proc call*(call_564191: Call_JobsUpdate_564181; apiVersion: string;
          jobResourceUpdateParameter: JsonNode; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobsUpdate
  ## Updates the properties of an existing job.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   jobResourceUpdateParameter: JObject (required)
  ##                             : Job update parameters from request body.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564192 = newJObject()
  var query_564193 = newJObject()
  var body_564194 = newJObject()
  add(query_564193, "api-version", newJString(apiVersion))
  if jobResourceUpdateParameter != nil:
    body_564194 = jobResourceUpdateParameter
  add(path_564192, "subscriptionId", newJString(subscriptionId))
  add(path_564192, "resourceGroupName", newJString(resourceGroupName))
  add(path_564192, "jobName", newJString(jobName))
  result = call_564191.call(path_564192, query_564193, nil, nil, body_564194)

var jobsUpdate* = Call_JobsUpdate_564181(name: "jobsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsUpdate_564182,
                                      base: "", url: url_JobsUpdate_564183,
                                      schemes: {Scheme.Https})
type
  Call_JobsDelete_564170 = ref object of OpenApiRestCall_563565
proc url_JobsDelete_564172(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsDelete_564171(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  var valid_564175 = path.getOrDefault("jobName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "jobName", valid_564175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564176 = query.getOrDefault("api-version")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "api-version", valid_564176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564177: Call_JobsDelete_564170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_564177.validator(path, query, header, formData, body)
  let scheme = call_564177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564177.url(scheme.get, call_564177.host, call_564177.base,
                         call_564177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564177, url, valid)

proc call*(call_564178: Call_JobsDelete_564170; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; jobName: string): Recallable =
  ## jobsDelete
  ## Deletes a job.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564179 = newJObject()
  var query_564180 = newJObject()
  add(query_564180, "api-version", newJString(apiVersion))
  add(path_564179, "subscriptionId", newJString(subscriptionId))
  add(path_564179, "resourceGroupName", newJString(resourceGroupName))
  add(path_564179, "jobName", newJString(jobName))
  result = call_564178.call(path_564179, query_564180, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_564170(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsDelete_564171,
                                      base: "", url: url_JobsDelete_564172,
                                      schemes: {Scheme.Https})
type
  Call_JobsBookShipmentPickUp_564195 = ref object of OpenApiRestCall_563565
proc url_JobsBookShipmentPickUp_564197(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/bookShipmentPickUp")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsBookShipmentPickUp_564196(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Book shipment pick up.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceGroupName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceGroupName", valid_564199
  var valid_564200 = path.getOrDefault("jobName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "jobName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "api-version", valid_564201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   shipmentPickUpRequest: JObject (required)
  ##                        : Details of shipment pick up request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_JobsBookShipmentPickUp_564195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Book shipment pick up.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_JobsBookShipmentPickUp_564195;
          shipmentPickUpRequest: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; jobName: string): Recallable =
  ## jobsBookShipmentPickUp
  ## Book shipment pick up.
  ##   shipmentPickUpRequest: JObject (required)
  ##                        : Details of shipment pick up request.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  var body_564207 = newJObject()
  if shipmentPickUpRequest != nil:
    body_564207 = shipmentPickUpRequest
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  add(path_564205, "jobName", newJString(jobName))
  result = call_564204.call(path_564205, query_564206, nil, nil, body_564207)

var jobsBookShipmentPickUp* = Call_JobsBookShipmentPickUp_564195(
    name: "jobsBookShipmentPickUp", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/bookShipmentPickUp",
    validator: validate_JobsBookShipmentPickUp_564196, base: "",
    url: url_JobsBookShipmentPickUp_564197, schemes: {Scheme.Https})
type
  Call_JobsCancel_564208 = ref object of OpenApiRestCall_563565
proc url_JobsCancel_564210(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCancel_564209(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## CancelJob.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  var valid_564213 = path.getOrDefault("jobName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "jobName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cancellationReason: JObject (required)
  ##                     : Reason for cancellation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564216: Call_JobsCancel_564208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## CancelJob.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_JobsCancel_564208; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          cancellationReason: JsonNode; jobName: string): Recallable =
  ## jobsCancel
  ## CancelJob.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   cancellationReason: JObject (required)
  ##                     : Reason for cancellation.
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  var body_564220 = newJObject()
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "subscriptionId", newJString(subscriptionId))
  add(path_564218, "resourceGroupName", newJString(resourceGroupName))
  if cancellationReason != nil:
    body_564220 = cancellationReason
  add(path_564218, "jobName", newJString(jobName))
  result = call_564217.call(path_564218, query_564219, nil, nil, body_564220)

var jobsCancel* = Call_JobsCancel_564208(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/cancel",
                                      validator: validate_JobsCancel_564209,
                                      base: "", url: url_JobsCancel_564210,
                                      schemes: {Scheme.Https})
type
  Call_JobsListCredentials_564221 = ref object of OpenApiRestCall_563565
proc url_JobsListCredentials_564223(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/listCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListCredentials_564222(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## This method gets the unencrypted secrets related to the job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564224 = path.getOrDefault("subscriptionId")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "subscriptionId", valid_564224
  var valid_564225 = path.getOrDefault("resourceGroupName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "resourceGroupName", valid_564225
  var valid_564226 = path.getOrDefault("jobName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "jobName", valid_564226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564227 = query.getOrDefault("api-version")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "api-version", valid_564227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564228: Call_JobsListCredentials_564221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the unencrypted secrets related to the job.
  ## 
  let valid = call_564228.validator(path, query, header, formData, body)
  let scheme = call_564228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564228.url(scheme.get, call_564228.host, call_564228.base,
                         call_564228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564228, url, valid)

proc call*(call_564229: Call_JobsListCredentials_564221; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; jobName: string): Recallable =
  ## jobsListCredentials
  ## This method gets the unencrypted secrets related to the job.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564230 = newJObject()
  var query_564231 = newJObject()
  add(query_564231, "api-version", newJString(apiVersion))
  add(path_564230, "subscriptionId", newJString(subscriptionId))
  add(path_564230, "resourceGroupName", newJString(resourceGroupName))
  add(path_564230, "jobName", newJString(jobName))
  result = call_564229.call(path_564230, query_564231, nil, nil, nil)

var jobsListCredentials* = Call_JobsListCredentials_564221(
    name: "jobsListCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/listCredentials",
    validator: validate_JobsListCredentials_564222, base: "",
    url: url_JobsListCredentials_564223, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
