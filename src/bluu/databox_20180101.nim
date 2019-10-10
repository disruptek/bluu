
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

  OpenApiRestCall_573667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573667): Option[Scheme] {.used.} =
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
  macServiceName = "databox"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573889 = ref object of OpenApiRestCall_573667
proc url_OperationsList_573891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573890(path: JsonNode; query: JsonNode;
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
  var valid_574050 = query.getOrDefault("api-version")
  valid_574050 = validateParameter(valid_574050, JString, required = true,
                                 default = nil)
  if valid_574050 != nil:
    section.add "api-version", valid_574050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574073: Call_OperationsList_573889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the operations.
  ## 
  let valid = call_574073.validator(path, query, header, formData, body)
  let scheme = call_574073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574073.url(scheme.get, call_574073.host, call_574073.base,
                         call_574073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574073, url, valid)

proc call*(call_574144: Call_OperationsList_573889; apiVersion: string): Recallable =
  ## operationsList
  ## This method gets all the operations.
  ##   apiVersion: string (required)
  ##             : The API Version
  var query_574145 = newJObject()
  add(query_574145, "api-version", newJString(apiVersion))
  result = call_574144.call(nil, query_574145, nil, nil, nil)

var operationsList* = Call_OperationsList_573889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataBox/operations",
    validator: validate_OperationsList_573890, base: "", url: url_OperationsList_573891,
    schemes: {Scheme.Https})
type
  Call_JobsList_574185 = ref object of OpenApiRestCall_573667
proc url_JobsList_574187(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsList_574186(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $skipToken: JString
  ##             : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574204 = query.getOrDefault("api-version")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "api-version", valid_574204
  var valid_574205 = query.getOrDefault("$skipToken")
  valid_574205 = validateParameter(valid_574205, JString, required = false,
                                 default = nil)
  if valid_574205 != nil:
    section.add "$skipToken", valid_574205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_JobsList_574185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the jobs available under the subscription.
  ## 
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_JobsList_574185; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## jobsList
  ## Lists all the jobs available under the subscription.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   SkipToken: string
  ##            : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  var path_574208 = newJObject()
  var query_574209 = newJObject()
  add(query_574209, "api-version", newJString(apiVersion))
  add(path_574208, "subscriptionId", newJString(subscriptionId))
  add(query_574209, "$skipToken", newJString(SkipToken))
  result = call_574207.call(path_574208, query_574209, nil, nil, nil)

var jobsList* = Call_JobsList_574185(name: "jobsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/jobs",
                                  validator: validate_JobsList_574186, base: "",
                                  url: url_JobsList_574187,
                                  schemes: {Scheme.Https})
type
  Call_ServiceListAvailableSkus_574210 = ref object of OpenApiRestCall_573667
proc url_ServiceListAvailableSkus_574212(protocol: Scheme; host: string;
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

proc validate_ServiceListAvailableSkus_574211(path: JsonNode; query: JsonNode;
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
  var valid_574213 = path.getOrDefault("subscriptionId")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "subscriptionId", valid_574213
  var valid_574214 = path.getOrDefault("location")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "location", valid_574214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574215 = query.getOrDefault("api-version")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "api-version", valid_574215
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

proc call*(call_574217: Call_ServiceListAvailableSkus_574210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method provides the list of available skus for the given subscription and location.
  ## 
  let valid = call_574217.validator(path, query, header, formData, body)
  let scheme = call_574217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574217.url(scheme.get, call_574217.host, call_574217.base,
                         call_574217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574217, url, valid)

proc call*(call_574218: Call_ServiceListAvailableSkus_574210; apiVersion: string;
          subscriptionId: string; availableSkuRequest: JsonNode; location: string): Recallable =
  ## serviceListAvailableSkus
  ## This method provides the list of available skus for the given subscription and location.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   availableSkuRequest: JObject (required)
  ##                      : Filters for showing the available skus.
  ##   location: string (required)
  ##           : The location of the resource
  var path_574219 = newJObject()
  var query_574220 = newJObject()
  var body_574221 = newJObject()
  add(query_574220, "api-version", newJString(apiVersion))
  add(path_574219, "subscriptionId", newJString(subscriptionId))
  if availableSkuRequest != nil:
    body_574221 = availableSkuRequest
  add(path_574219, "location", newJString(location))
  result = call_574218.call(path_574219, query_574220, nil, nil, body_574221)

var serviceListAvailableSkus* = Call_ServiceListAvailableSkus_574210(
    name: "serviceListAvailableSkus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/locations/{location}/availableSkus",
    validator: validate_ServiceListAvailableSkus_574211, base: "",
    url: url_ServiceListAvailableSkus_574212, schemes: {Scheme.Https})
type
  Call_ServiceValidateAddress_574222 = ref object of OpenApiRestCall_573667
proc url_ServiceValidateAddress_574224(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceValidateAddress_574223(path: JsonNode; query: JsonNode;
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
  var valid_574225 = path.getOrDefault("subscriptionId")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "subscriptionId", valid_574225
  var valid_574226 = path.getOrDefault("location")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "location", valid_574226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574227 = query.getOrDefault("api-version")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "api-version", valid_574227
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

proc call*(call_574229: Call_ServiceValidateAddress_574222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method validates the customer shipping address and provide alternate addresses if any.
  ## 
  let valid = call_574229.validator(path, query, header, formData, body)
  let scheme = call_574229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574229.url(scheme.get, call_574229.host, call_574229.base,
                         call_574229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574229, url, valid)

proc call*(call_574230: Call_ServiceValidateAddress_574222;
          validateAddress: JsonNode; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## serviceValidateAddress
  ## This method validates the customer shipping address and provide alternate addresses if any.
  ##   validateAddress: JObject (required)
  ##                  : Shipping address of the customer.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   location: string (required)
  ##           : The location of the resource
  var path_574231 = newJObject()
  var query_574232 = newJObject()
  var body_574233 = newJObject()
  if validateAddress != nil:
    body_574233 = validateAddress
  add(query_574232, "api-version", newJString(apiVersion))
  add(path_574231, "subscriptionId", newJString(subscriptionId))
  add(path_574231, "location", newJString(location))
  result = call_574230.call(path_574231, query_574232, nil, nil, body_574233)

var serviceValidateAddress* = Call_ServiceValidateAddress_574222(
    name: "serviceValidateAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/locations/{location}/validateAddress",
    validator: validate_ServiceValidateAddress_574223, base: "",
    url: url_ServiceValidateAddress_574224, schemes: {Scheme.Https})
type
  Call_JobsListByResourceGroup_574234 = ref object of OpenApiRestCall_573667
proc url_JobsListByResourceGroup_574236(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByResourceGroup_574235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the jobs available under the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574237 = path.getOrDefault("resourceGroupName")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "resourceGroupName", valid_574237
  var valid_574238 = path.getOrDefault("subscriptionId")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "subscriptionId", valid_574238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $skipToken: JString
  ##             : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574239 = query.getOrDefault("api-version")
  valid_574239 = validateParameter(valid_574239, JString, required = true,
                                 default = nil)
  if valid_574239 != nil:
    section.add "api-version", valid_574239
  var valid_574240 = query.getOrDefault("$skipToken")
  valid_574240 = validateParameter(valid_574240, JString, required = false,
                                 default = nil)
  if valid_574240 != nil:
    section.add "$skipToken", valid_574240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574241: Call_JobsListByResourceGroup_574234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the jobs available under the given resource group.
  ## 
  let valid = call_574241.validator(path, query, header, formData, body)
  let scheme = call_574241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574241.url(scheme.get, call_574241.host, call_574241.base,
                         call_574241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574241, url, valid)

proc call*(call_574242: Call_JobsListByResourceGroup_574234;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          SkipToken: string = ""): Recallable =
  ## jobsListByResourceGroup
  ## Lists all the jobs available under the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   SkipToken: string
  ##            : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  var path_574243 = newJObject()
  var query_574244 = newJObject()
  add(path_574243, "resourceGroupName", newJString(resourceGroupName))
  add(query_574244, "api-version", newJString(apiVersion))
  add(path_574243, "subscriptionId", newJString(subscriptionId))
  add(query_574244, "$skipToken", newJString(SkipToken))
  result = call_574242.call(path_574243, query_574244, nil, nil, nil)

var jobsListByResourceGroup* = Call_JobsListByResourceGroup_574234(
    name: "jobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs",
    validator: validate_JobsListByResourceGroup_574235, base: "",
    url: url_JobsListByResourceGroup_574236, schemes: {Scheme.Https})
type
  Call_JobsCreate_574257 = ref object of OpenApiRestCall_573667
proc url_JobsCreate_574259(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCreate_574258(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new job with the specified parameters. Existing job cannot be updated with this API and should instead be updated with the Update job API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574260 = path.getOrDefault("resourceGroupName")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "resourceGroupName", valid_574260
  var valid_574261 = path.getOrDefault("subscriptionId")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "subscriptionId", valid_574261
  var valid_574262 = path.getOrDefault("jobName")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "jobName", valid_574262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574263 = query.getOrDefault("api-version")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "api-version", valid_574263
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

proc call*(call_574265: Call_JobsCreate_574257; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job with the specified parameters. Existing job cannot be updated with this API and should instead be updated with the Update job API.
  ## 
  let valid = call_574265.validator(path, query, header, formData, body)
  let scheme = call_574265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574265.url(scheme.get, call_574265.host, call_574265.base,
                         call_574265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574265, url, valid)

proc call*(call_574266: Call_JobsCreate_574257; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          jobResource: JsonNode): Recallable =
  ## jobsCreate
  ## Creates a new job with the specified parameters. Existing job cannot be updated with this API and should instead be updated with the Update job API.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobResource: JObject (required)
  ##              : Job details from request body.
  var path_574267 = newJObject()
  var query_574268 = newJObject()
  var body_574269 = newJObject()
  add(path_574267, "resourceGroupName", newJString(resourceGroupName))
  add(query_574268, "api-version", newJString(apiVersion))
  add(path_574267, "subscriptionId", newJString(subscriptionId))
  add(path_574267, "jobName", newJString(jobName))
  if jobResource != nil:
    body_574269 = jobResource
  result = call_574266.call(path_574267, query_574268, nil, nil, body_574269)

var jobsCreate* = Call_JobsCreate_574257(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsCreate_574258,
                                      base: "", url: url_JobsCreate_574259,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_574245 = ref object of OpenApiRestCall_573667
proc url_JobsGet_574247(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_574246(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574248 = path.getOrDefault("resourceGroupName")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "resourceGroupName", valid_574248
  var valid_574249 = path.getOrDefault("subscriptionId")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "subscriptionId", valid_574249
  var valid_574250 = path.getOrDefault("jobName")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "jobName", valid_574250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $expand: JString
  ##          : $expand is supported on details parameter for job, which provides details on the job stages.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574251 = query.getOrDefault("api-version")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "api-version", valid_574251
  var valid_574252 = query.getOrDefault("$expand")
  valid_574252 = validateParameter(valid_574252, JString, required = false,
                                 default = nil)
  if valid_574252 != nil:
    section.add "$expand", valid_574252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574253: Call_JobsGet_574245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified job.
  ## 
  let valid = call_574253.validator(path, query, header, formData, body)
  let scheme = call_574253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574253.url(scheme.get, call_574253.host, call_574253.base,
                         call_574253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574253, url, valid)

proc call*(call_574254: Call_JobsGet_574245; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          Expand: string = ""): Recallable =
  ## jobsGet
  ## Gets information about the specified job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   Expand: string
  ##         : $expand is supported on details parameter for job, which provides details on the job stages.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_574255 = newJObject()
  var query_574256 = newJObject()
  add(path_574255, "resourceGroupName", newJString(resourceGroupName))
  add(query_574256, "api-version", newJString(apiVersion))
  add(query_574256, "$expand", newJString(Expand))
  add(path_574255, "subscriptionId", newJString(subscriptionId))
  add(path_574255, "jobName", newJString(jobName))
  result = call_574254.call(path_574255, query_574256, nil, nil, nil)

var jobsGet* = Call_JobsGet_574245(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                validator: validate_JobsGet_574246, base: "",
                                url: url_JobsGet_574247, schemes: {Scheme.Https})
type
  Call_JobsUpdate_574281 = ref object of OpenApiRestCall_573667
proc url_JobsUpdate_574283(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsUpdate_574282(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the properties of an existing job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574284 = path.getOrDefault("resourceGroupName")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "resourceGroupName", valid_574284
  var valid_574285 = path.getOrDefault("subscriptionId")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "subscriptionId", valid_574285
  var valid_574286 = path.getOrDefault("jobName")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "jobName", valid_574286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574287 = query.getOrDefault("api-version")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "api-version", valid_574287
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The patch will be performed only if the ETag of the job on the server matches this value.
  section = newJObject()
  var valid_574288 = header.getOrDefault("If-Match")
  valid_574288 = validateParameter(valid_574288, JString, required = false,
                                 default = nil)
  if valid_574288 != nil:
    section.add "If-Match", valid_574288
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

proc call*(call_574290: Call_JobsUpdate_574281; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing job.
  ## 
  let valid = call_574290.validator(path, query, header, formData, body)
  let scheme = call_574290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574290.url(scheme.get, call_574290.host, call_574290.base,
                         call_574290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574290, url, valid)

proc call*(call_574291: Call_JobsUpdate_574281; resourceGroupName: string;
          apiVersion: string; jobResourceUpdateParameter: JsonNode;
          subscriptionId: string; jobName: string): Recallable =
  ## jobsUpdate
  ## Updates the properties of an existing job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   jobResourceUpdateParameter: JObject (required)
  ##                             : Job update parameters from request body.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_574292 = newJObject()
  var query_574293 = newJObject()
  var body_574294 = newJObject()
  add(path_574292, "resourceGroupName", newJString(resourceGroupName))
  add(query_574293, "api-version", newJString(apiVersion))
  if jobResourceUpdateParameter != nil:
    body_574294 = jobResourceUpdateParameter
  add(path_574292, "subscriptionId", newJString(subscriptionId))
  add(path_574292, "jobName", newJString(jobName))
  result = call_574291.call(path_574292, query_574293, nil, nil, body_574294)

var jobsUpdate* = Call_JobsUpdate_574281(name: "jobsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsUpdate_574282,
                                      base: "", url: url_JobsUpdate_574283,
                                      schemes: {Scheme.Https})
type
  Call_JobsDelete_574270 = ref object of OpenApiRestCall_573667
proc url_JobsDelete_574272(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsDelete_574271(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574273 = path.getOrDefault("resourceGroupName")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "resourceGroupName", valid_574273
  var valid_574274 = path.getOrDefault("subscriptionId")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "subscriptionId", valid_574274
  var valid_574275 = path.getOrDefault("jobName")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "jobName", valid_574275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574276 = query.getOrDefault("api-version")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "api-version", valid_574276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574277: Call_JobsDelete_574270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_574277.validator(path, query, header, formData, body)
  let scheme = call_574277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574277.url(scheme.get, call_574277.host, call_574277.base,
                         call_574277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574277, url, valid)

proc call*(call_574278: Call_JobsDelete_574270; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## jobsDelete
  ## Deletes a job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_574279 = newJObject()
  var query_574280 = newJObject()
  add(path_574279, "resourceGroupName", newJString(resourceGroupName))
  add(query_574280, "api-version", newJString(apiVersion))
  add(path_574279, "subscriptionId", newJString(subscriptionId))
  add(path_574279, "jobName", newJString(jobName))
  result = call_574278.call(path_574279, query_574280, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_574270(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsDelete_574271,
                                      base: "", url: url_JobsDelete_574272,
                                      schemes: {Scheme.Https})
type
  Call_JobsBookShipmentPickUp_574295 = ref object of OpenApiRestCall_573667
proc url_JobsBookShipmentPickUp_574297(protocol: Scheme; host: string; base: string;
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

proc validate_JobsBookShipmentPickUp_574296(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Book shipment pick up.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574298 = path.getOrDefault("resourceGroupName")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "resourceGroupName", valid_574298
  var valid_574299 = path.getOrDefault("subscriptionId")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "subscriptionId", valid_574299
  var valid_574300 = path.getOrDefault("jobName")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "jobName", valid_574300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574301 = query.getOrDefault("api-version")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "api-version", valid_574301
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

proc call*(call_574303: Call_JobsBookShipmentPickUp_574295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Book shipment pick up.
  ## 
  let valid = call_574303.validator(path, query, header, formData, body)
  let scheme = call_574303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574303.url(scheme.get, call_574303.host, call_574303.base,
                         call_574303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574303, url, valid)

proc call*(call_574304: Call_JobsBookShipmentPickUp_574295;
          resourceGroupName: string; shipmentPickUpRequest: JsonNode;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## jobsBookShipmentPickUp
  ## Book shipment pick up.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   shipmentPickUpRequest: JObject (required)
  ##                        : Details of shipment pick up request.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_574305 = newJObject()
  var query_574306 = newJObject()
  var body_574307 = newJObject()
  add(path_574305, "resourceGroupName", newJString(resourceGroupName))
  if shipmentPickUpRequest != nil:
    body_574307 = shipmentPickUpRequest
  add(query_574306, "api-version", newJString(apiVersion))
  add(path_574305, "subscriptionId", newJString(subscriptionId))
  add(path_574305, "jobName", newJString(jobName))
  result = call_574304.call(path_574305, query_574306, nil, nil, body_574307)

var jobsBookShipmentPickUp* = Call_JobsBookShipmentPickUp_574295(
    name: "jobsBookShipmentPickUp", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/bookShipmentPickUp",
    validator: validate_JobsBookShipmentPickUp_574296, base: "",
    url: url_JobsBookShipmentPickUp_574297, schemes: {Scheme.Https})
type
  Call_JobsCancel_574308 = ref object of OpenApiRestCall_573667
proc url_JobsCancel_574310(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCancel_574309(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## CancelJob.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574311 = path.getOrDefault("resourceGroupName")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "resourceGroupName", valid_574311
  var valid_574312 = path.getOrDefault("subscriptionId")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "subscriptionId", valid_574312
  var valid_574313 = path.getOrDefault("jobName")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "jobName", valid_574313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574314 = query.getOrDefault("api-version")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "api-version", valid_574314
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

proc call*(call_574316: Call_JobsCancel_574308; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## CancelJob.
  ## 
  let valid = call_574316.validator(path, query, header, formData, body)
  let scheme = call_574316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574316.url(scheme.get, call_574316.host, call_574316.base,
                         call_574316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574316, url, valid)

proc call*(call_574317: Call_JobsCancel_574308; resourceGroupName: string;
          apiVersion: string; cancellationReason: JsonNode; subscriptionId: string;
          jobName: string): Recallable =
  ## jobsCancel
  ## CancelJob.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   cancellationReason: JObject (required)
  ##                     : Reason for cancellation.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_574318 = newJObject()
  var query_574319 = newJObject()
  var body_574320 = newJObject()
  add(path_574318, "resourceGroupName", newJString(resourceGroupName))
  add(query_574319, "api-version", newJString(apiVersion))
  if cancellationReason != nil:
    body_574320 = cancellationReason
  add(path_574318, "subscriptionId", newJString(subscriptionId))
  add(path_574318, "jobName", newJString(jobName))
  result = call_574317.call(path_574318, query_574319, nil, nil, body_574320)

var jobsCancel* = Call_JobsCancel_574308(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/cancel",
                                      validator: validate_JobsCancel_574309,
                                      base: "", url: url_JobsCancel_574310,
                                      schemes: {Scheme.Https})
type
  Call_JobsListCredentials_574321 = ref object of OpenApiRestCall_573667
proc url_JobsListCredentials_574323(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListCredentials_574322(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## This method gets the unencrypted secrets related to the job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobName: JString (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574324 = path.getOrDefault("resourceGroupName")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "resourceGroupName", valid_574324
  var valid_574325 = path.getOrDefault("subscriptionId")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "subscriptionId", valid_574325
  var valid_574326 = path.getOrDefault("jobName")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "jobName", valid_574326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574327 = query.getOrDefault("api-version")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "api-version", valid_574327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574328: Call_JobsListCredentials_574321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the unencrypted secrets related to the job.
  ## 
  let valid = call_574328.validator(path, query, header, formData, body)
  let scheme = call_574328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574328.url(scheme.get, call_574328.host, call_574328.base,
                         call_574328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574328, url, valid)

proc call*(call_574329: Call_JobsListCredentials_574321; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## jobsListCredentials
  ## This method gets the unencrypted secrets related to the job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobName: string (required)
  ##          : The name of the job Resource within the specified resource group. job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_574330 = newJObject()
  var query_574331 = newJObject()
  add(path_574330, "resourceGroupName", newJString(resourceGroupName))
  add(query_574331, "api-version", newJString(apiVersion))
  add(path_574330, "subscriptionId", newJString(subscriptionId))
  add(path_574330, "jobName", newJString(jobName))
  result = call_574329.call(path_574330, query_574331, nil, nil, nil)

var jobsListCredentials* = Call_JobsListCredentials_574321(
    name: "jobsListCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/listCredentials",
    validator: validate_JobsListCredentials_574322, base: "",
    url: url_JobsListCredentials_574323, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
