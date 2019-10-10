
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataBoxManagementClient
## version: 2019-09-01
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
  Call_ServiceRegionConfiguration_574222 = ref object of OpenApiRestCall_573667
proc url_ServiceRegionConfiguration_574224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/regionConfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRegionConfiguration_574223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API provides configuration details specific to given region/location.
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
  ##   regionConfigurationRequest: JObject (required)
  ##                             : Request body to get the configuration for the region.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574229: Call_ServiceRegionConfiguration_574222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API provides configuration details specific to given region/location.
  ## 
  let valid = call_574229.validator(path, query, header, formData, body)
  let scheme = call_574229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574229.url(scheme.get, call_574229.host, call_574229.base,
                         call_574229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574229, url, valid)

proc call*(call_574230: Call_ServiceRegionConfiguration_574222;
          regionConfigurationRequest: JsonNode; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## serviceRegionConfiguration
  ## This API provides configuration details specific to given region/location.
  ##   regionConfigurationRequest: JObject (required)
  ##                             : Request body to get the configuration for the region.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   location: string (required)
  ##           : The location of the resource
  var path_574231 = newJObject()
  var query_574232 = newJObject()
  var body_574233 = newJObject()
  if regionConfigurationRequest != nil:
    body_574233 = regionConfigurationRequest
  add(query_574232, "api-version", newJString(apiVersion))
  add(path_574231, "subscriptionId", newJString(subscriptionId))
  add(path_574231, "location", newJString(location))
  result = call_574230.call(path_574231, query_574232, nil, nil, body_574233)

var serviceRegionConfiguration* = Call_ServiceRegionConfiguration_574222(
    name: "serviceRegionConfiguration", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/locations/{location}/regionConfiguration",
    validator: validate_ServiceRegionConfiguration_574223, base: "",
    url: url_ServiceRegionConfiguration_574224, schemes: {Scheme.Https})
type
  Call_ServiceValidateAddress_574234 = ref object of OpenApiRestCall_573667
proc url_ServiceValidateAddress_574236(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceValidateAddress_574235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] This method validates the customer shipping address and provide alternate addresses if any.
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
  var valid_574237 = path.getOrDefault("subscriptionId")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "subscriptionId", valid_574237
  var valid_574238 = path.getOrDefault("location")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "location", valid_574238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574239 = query.getOrDefault("api-version")
  valid_574239 = validateParameter(valid_574239, JString, required = true,
                                 default = nil)
  if valid_574239 != nil:
    section.add "api-version", valid_574239
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

proc call*(call_574241: Call_ServiceValidateAddress_574234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] This method validates the customer shipping address and provide alternate addresses if any.
  ## 
  let valid = call_574241.validator(path, query, header, formData, body)
  let scheme = call_574241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574241.url(scheme.get, call_574241.host, call_574241.base,
                         call_574241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574241, url, valid)

proc call*(call_574242: Call_ServiceValidateAddress_574234;
          validateAddress: JsonNode; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## serviceValidateAddress
  ## [DEPRECATED NOTICE: This operation will soon be removed] This method validates the customer shipping address and provide alternate addresses if any.
  ##   validateAddress: JObject (required)
  ##                  : Shipping address of the customer.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   location: string (required)
  ##           : The location of the resource
  var path_574243 = newJObject()
  var query_574244 = newJObject()
  var body_574245 = newJObject()
  if validateAddress != nil:
    body_574245 = validateAddress
  add(query_574244, "api-version", newJString(apiVersion))
  add(path_574243, "subscriptionId", newJString(subscriptionId))
  add(path_574243, "location", newJString(location))
  result = call_574242.call(path_574243, query_574244, nil, nil, body_574245)

var serviceValidateAddress* = Call_ServiceValidateAddress_574234(
    name: "serviceValidateAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/locations/{location}/validateAddress",
    validator: validate_ServiceValidateAddress_574235, base: "",
    url: url_ServiceValidateAddress_574236, schemes: {Scheme.Https})
type
  Call_ServiceValidateInputs_574246 = ref object of OpenApiRestCall_573667
proc url_ServiceValidateInputs_574248(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/validateInputs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceValidateInputs_574247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method does all necessary pre-job creation validation under subscription.
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
  var valid_574249 = path.getOrDefault("subscriptionId")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "subscriptionId", valid_574249
  var valid_574250 = path.getOrDefault("location")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "location", valid_574250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574251 = query.getOrDefault("api-version")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "api-version", valid_574251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   validationRequest: JObject (required)
  ##                    : Inputs of the customer.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574253: Call_ServiceValidateInputs_574246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method does all necessary pre-job creation validation under subscription.
  ## 
  let valid = call_574253.validator(path, query, header, formData, body)
  let scheme = call_574253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574253.url(scheme.get, call_574253.host, call_574253.base,
                         call_574253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574253, url, valid)

proc call*(call_574254: Call_ServiceValidateInputs_574246; apiVersion: string;
          subscriptionId: string; validationRequest: JsonNode; location: string): Recallable =
  ## serviceValidateInputs
  ## This method does all necessary pre-job creation validation under subscription.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   validationRequest: JObject (required)
  ##                    : Inputs of the customer.
  ##   location: string (required)
  ##           : The location of the resource
  var path_574255 = newJObject()
  var query_574256 = newJObject()
  var body_574257 = newJObject()
  add(query_574256, "api-version", newJString(apiVersion))
  add(path_574255, "subscriptionId", newJString(subscriptionId))
  if validationRequest != nil:
    body_574257 = validationRequest
  add(path_574255, "location", newJString(location))
  result = call_574254.call(path_574255, query_574256, nil, nil, body_574257)

var serviceValidateInputs* = Call_ServiceValidateInputs_574246(
    name: "serviceValidateInputs", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBox/locations/{location}/validateInputs",
    validator: validate_ServiceValidateInputs_574247, base: "",
    url: url_ServiceValidateInputs_574248, schemes: {Scheme.Https})
type
  Call_JobsListByResourceGroup_574258 = ref object of OpenApiRestCall_573667
proc url_JobsListByResourceGroup_574260(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByResourceGroup_574259(path: JsonNode; query: JsonNode;
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
  var valid_574261 = path.getOrDefault("resourceGroupName")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "resourceGroupName", valid_574261
  var valid_574262 = path.getOrDefault("subscriptionId")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "subscriptionId", valid_574262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $skipToken: JString
  ##             : $skipToken is supported on Get list of jobs, which provides the next page in the list of jobs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574263 = query.getOrDefault("api-version")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "api-version", valid_574263
  var valid_574264 = query.getOrDefault("$skipToken")
  valid_574264 = validateParameter(valid_574264, JString, required = false,
                                 default = nil)
  if valid_574264 != nil:
    section.add "$skipToken", valid_574264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574265: Call_JobsListByResourceGroup_574258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the jobs available under the given resource group.
  ## 
  let valid = call_574265.validator(path, query, header, formData, body)
  let scheme = call_574265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574265.url(scheme.get, call_574265.host, call_574265.base,
                         call_574265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574265, url, valid)

proc call*(call_574266: Call_JobsListByResourceGroup_574258;
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
  var path_574267 = newJObject()
  var query_574268 = newJObject()
  add(path_574267, "resourceGroupName", newJString(resourceGroupName))
  add(query_574268, "api-version", newJString(apiVersion))
  add(path_574267, "subscriptionId", newJString(subscriptionId))
  add(query_574268, "$skipToken", newJString(SkipToken))
  result = call_574266.call(path_574267, query_574268, nil, nil, nil)

var jobsListByResourceGroup* = Call_JobsListByResourceGroup_574258(
    name: "jobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs",
    validator: validate_JobsListByResourceGroup_574259, base: "",
    url: url_JobsListByResourceGroup_574260, schemes: {Scheme.Https})
type
  Call_JobsCreate_574281 = ref object of OpenApiRestCall_573667
proc url_JobsCreate_574283(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCreate_574282(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_574289: Call_JobsCreate_574281; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job with the specified parameters. Existing job cannot be updated with this API and should instead be updated with the Update job API.
  ## 
  let valid = call_574289.validator(path, query, header, formData, body)
  let scheme = call_574289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574289.url(scheme.get, call_574289.host, call_574289.base,
                         call_574289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574289, url, valid)

proc call*(call_574290: Call_JobsCreate_574281; resourceGroupName: string;
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
  var path_574291 = newJObject()
  var query_574292 = newJObject()
  var body_574293 = newJObject()
  add(path_574291, "resourceGroupName", newJString(resourceGroupName))
  add(query_574292, "api-version", newJString(apiVersion))
  add(path_574291, "subscriptionId", newJString(subscriptionId))
  add(path_574291, "jobName", newJString(jobName))
  if jobResource != nil:
    body_574293 = jobResource
  result = call_574290.call(path_574291, query_574292, nil, nil, body_574293)

var jobsCreate* = Call_JobsCreate_574281(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsCreate_574282,
                                      base: "", url: url_JobsCreate_574283,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_574269 = ref object of OpenApiRestCall_573667
proc url_JobsGet_574271(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_574270(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574272 = path.getOrDefault("resourceGroupName")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "resourceGroupName", valid_574272
  var valid_574273 = path.getOrDefault("subscriptionId")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "subscriptionId", valid_574273
  var valid_574274 = path.getOrDefault("jobName")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "jobName", valid_574274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $expand: JString
  ##          : $expand is supported on details parameter for job, which provides details on the job stages.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574275 = query.getOrDefault("api-version")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "api-version", valid_574275
  var valid_574276 = query.getOrDefault("$expand")
  valid_574276 = validateParameter(valid_574276, JString, required = false,
                                 default = nil)
  if valid_574276 != nil:
    section.add "$expand", valid_574276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574277: Call_JobsGet_574269; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified job.
  ## 
  let valid = call_574277.validator(path, query, header, formData, body)
  let scheme = call_574277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574277.url(scheme.get, call_574277.host, call_574277.base,
                         call_574277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574277, url, valid)

proc call*(call_574278: Call_JobsGet_574269; resourceGroupName: string;
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
  var path_574279 = newJObject()
  var query_574280 = newJObject()
  add(path_574279, "resourceGroupName", newJString(resourceGroupName))
  add(query_574280, "api-version", newJString(apiVersion))
  add(query_574280, "$expand", newJString(Expand))
  add(path_574279, "subscriptionId", newJString(subscriptionId))
  add(path_574279, "jobName", newJString(jobName))
  result = call_574278.call(path_574279, query_574280, nil, nil, nil)

var jobsGet* = Call_JobsGet_574269(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                validator: validate_JobsGet_574270, base: "",
                                url: url_JobsGet_574271, schemes: {Scheme.Https})
type
  Call_JobsUpdate_574305 = ref object of OpenApiRestCall_573667
proc url_JobsUpdate_574307(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsUpdate_574306(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574308 = path.getOrDefault("resourceGroupName")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "resourceGroupName", valid_574308
  var valid_574309 = path.getOrDefault("subscriptionId")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "subscriptionId", valid_574309
  var valid_574310 = path.getOrDefault("jobName")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "jobName", valid_574310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574311 = query.getOrDefault("api-version")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "api-version", valid_574311
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The patch will be performed only if the ETag of the job on the server matches this value.
  section = newJObject()
  var valid_574312 = header.getOrDefault("If-Match")
  valid_574312 = validateParameter(valid_574312, JString, required = false,
                                 default = nil)
  if valid_574312 != nil:
    section.add "If-Match", valid_574312
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

proc call*(call_574314: Call_JobsUpdate_574305; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing job.
  ## 
  let valid = call_574314.validator(path, query, header, formData, body)
  let scheme = call_574314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574314.url(scheme.get, call_574314.host, call_574314.base,
                         call_574314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574314, url, valid)

proc call*(call_574315: Call_JobsUpdate_574305; resourceGroupName: string;
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
  var path_574316 = newJObject()
  var query_574317 = newJObject()
  var body_574318 = newJObject()
  add(path_574316, "resourceGroupName", newJString(resourceGroupName))
  add(query_574317, "api-version", newJString(apiVersion))
  if jobResourceUpdateParameter != nil:
    body_574318 = jobResourceUpdateParameter
  add(path_574316, "subscriptionId", newJString(subscriptionId))
  add(path_574316, "jobName", newJString(jobName))
  result = call_574315.call(path_574316, query_574317, nil, nil, body_574318)

var jobsUpdate* = Call_JobsUpdate_574305(name: "jobsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsUpdate_574306,
                                      base: "", url: url_JobsUpdate_574307,
                                      schemes: {Scheme.Https})
type
  Call_JobsDelete_574294 = ref object of OpenApiRestCall_573667
proc url_JobsDelete_574296(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsDelete_574295(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574297 = path.getOrDefault("resourceGroupName")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "resourceGroupName", valid_574297
  var valid_574298 = path.getOrDefault("subscriptionId")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "subscriptionId", valid_574298
  var valid_574299 = path.getOrDefault("jobName")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "jobName", valid_574299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574300 = query.getOrDefault("api-version")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "api-version", valid_574300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574301: Call_JobsDelete_574294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_574301.validator(path, query, header, formData, body)
  let scheme = call_574301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574301.url(scheme.get, call_574301.host, call_574301.base,
                         call_574301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574301, url, valid)

proc call*(call_574302: Call_JobsDelete_574294; resourceGroupName: string;
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
  var path_574303 = newJObject()
  var query_574304 = newJObject()
  add(path_574303, "resourceGroupName", newJString(resourceGroupName))
  add(query_574304, "api-version", newJString(apiVersion))
  add(path_574303, "subscriptionId", newJString(subscriptionId))
  add(path_574303, "jobName", newJString(jobName))
  result = call_574302.call(path_574303, query_574304, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_574294(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}",
                                      validator: validate_JobsDelete_574295,
                                      base: "", url: url_JobsDelete_574296,
                                      schemes: {Scheme.Https})
type
  Call_JobsBookShipmentPickUp_574319 = ref object of OpenApiRestCall_573667
proc url_JobsBookShipmentPickUp_574321(protocol: Scheme; host: string; base: string;
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

proc validate_JobsBookShipmentPickUp_574320(path: JsonNode; query: JsonNode;
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
  var valid_574322 = path.getOrDefault("resourceGroupName")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "resourceGroupName", valid_574322
  var valid_574323 = path.getOrDefault("subscriptionId")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "subscriptionId", valid_574323
  var valid_574324 = path.getOrDefault("jobName")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "jobName", valid_574324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574325 = query.getOrDefault("api-version")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "api-version", valid_574325
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

proc call*(call_574327: Call_JobsBookShipmentPickUp_574319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Book shipment pick up.
  ## 
  let valid = call_574327.validator(path, query, header, formData, body)
  let scheme = call_574327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574327.url(scheme.get, call_574327.host, call_574327.base,
                         call_574327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574327, url, valid)

proc call*(call_574328: Call_JobsBookShipmentPickUp_574319;
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
  var path_574329 = newJObject()
  var query_574330 = newJObject()
  var body_574331 = newJObject()
  add(path_574329, "resourceGroupName", newJString(resourceGroupName))
  if shipmentPickUpRequest != nil:
    body_574331 = shipmentPickUpRequest
  add(query_574330, "api-version", newJString(apiVersion))
  add(path_574329, "subscriptionId", newJString(subscriptionId))
  add(path_574329, "jobName", newJString(jobName))
  result = call_574328.call(path_574329, query_574330, nil, nil, body_574331)

var jobsBookShipmentPickUp* = Call_JobsBookShipmentPickUp_574319(
    name: "jobsBookShipmentPickUp", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/bookShipmentPickUp",
    validator: validate_JobsBookShipmentPickUp_574320, base: "",
    url: url_JobsBookShipmentPickUp_574321, schemes: {Scheme.Https})
type
  Call_JobsCancel_574332 = ref object of OpenApiRestCall_573667
proc url_JobsCancel_574334(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCancel_574333(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574335 = path.getOrDefault("resourceGroupName")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "resourceGroupName", valid_574335
  var valid_574336 = path.getOrDefault("subscriptionId")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "subscriptionId", valid_574336
  var valid_574337 = path.getOrDefault("jobName")
  valid_574337 = validateParameter(valid_574337, JString, required = true,
                                 default = nil)
  if valid_574337 != nil:
    section.add "jobName", valid_574337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574338 = query.getOrDefault("api-version")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "api-version", valid_574338
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

proc call*(call_574340: Call_JobsCancel_574332; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## CancelJob.
  ## 
  let valid = call_574340.validator(path, query, header, formData, body)
  let scheme = call_574340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574340.url(scheme.get, call_574340.host, call_574340.base,
                         call_574340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574340, url, valid)

proc call*(call_574341: Call_JobsCancel_574332; resourceGroupName: string;
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
  var path_574342 = newJObject()
  var query_574343 = newJObject()
  var body_574344 = newJObject()
  add(path_574342, "resourceGroupName", newJString(resourceGroupName))
  add(query_574343, "api-version", newJString(apiVersion))
  if cancellationReason != nil:
    body_574344 = cancellationReason
  add(path_574342, "subscriptionId", newJString(subscriptionId))
  add(path_574342, "jobName", newJString(jobName))
  result = call_574341.call(path_574342, query_574343, nil, nil, body_574344)

var jobsCancel* = Call_JobsCancel_574332(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/cancel",
                                      validator: validate_JobsCancel_574333,
                                      base: "", url: url_JobsCancel_574334,
                                      schemes: {Scheme.Https})
type
  Call_JobsListCredentials_574345 = ref object of OpenApiRestCall_573667
proc url_JobsListCredentials_574347(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListCredentials_574346(path: JsonNode; query: JsonNode;
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
  var valid_574348 = path.getOrDefault("resourceGroupName")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "resourceGroupName", valid_574348
  var valid_574349 = path.getOrDefault("subscriptionId")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "subscriptionId", valid_574349
  var valid_574350 = path.getOrDefault("jobName")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "jobName", valid_574350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574351 = query.getOrDefault("api-version")
  valid_574351 = validateParameter(valid_574351, JString, required = true,
                                 default = nil)
  if valid_574351 != nil:
    section.add "api-version", valid_574351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574352: Call_JobsListCredentials_574345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the unencrypted secrets related to the job.
  ## 
  let valid = call_574352.validator(path, query, header, formData, body)
  let scheme = call_574352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574352.url(scheme.get, call_574352.host, call_574352.base,
                         call_574352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574352, url, valid)

proc call*(call_574353: Call_JobsListCredentials_574345; resourceGroupName: string;
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
  var path_574354 = newJObject()
  var query_574355 = newJObject()
  add(path_574354, "resourceGroupName", newJString(resourceGroupName))
  add(query_574355, "api-version", newJString(apiVersion))
  add(path_574354, "subscriptionId", newJString(subscriptionId))
  add(path_574354, "jobName", newJString(jobName))
  result = call_574353.call(path_574354, query_574355, nil, nil, nil)

var jobsListCredentials* = Call_JobsListCredentials_574345(
    name: "jobsListCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/jobs/{jobName}/listCredentials",
    validator: validate_JobsListCredentials_574346, base: "",
    url: url_JobsListCredentials_574347, schemes: {Scheme.Https})
type
  Call_ServiceListAvailableSkusByResourceGroup_574356 = ref object of OpenApiRestCall_573667
proc url_ServiceListAvailableSkusByResourceGroup_574358(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/availableSkus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceListAvailableSkusByResourceGroup_574357(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method provides the list of available skus for the given subscription, resource group and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   location: JString (required)
  ##           : The location of the resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574359 = path.getOrDefault("resourceGroupName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "resourceGroupName", valid_574359
  var valid_574360 = path.getOrDefault("subscriptionId")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "subscriptionId", valid_574360
  var valid_574361 = path.getOrDefault("location")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "location", valid_574361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574362 = query.getOrDefault("api-version")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = nil)
  if valid_574362 != nil:
    section.add "api-version", valid_574362
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

proc call*(call_574364: Call_ServiceListAvailableSkusByResourceGroup_574356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method provides the list of available skus for the given subscription, resource group and location.
  ## 
  let valid = call_574364.validator(path, query, header, formData, body)
  let scheme = call_574364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574364.url(scheme.get, call_574364.host, call_574364.base,
                         call_574364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574364, url, valid)

proc call*(call_574365: Call_ServiceListAvailableSkusByResourceGroup_574356;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          availableSkuRequest: JsonNode; location: string): Recallable =
  ## serviceListAvailableSkusByResourceGroup
  ## This method provides the list of available skus for the given subscription, resource group and location.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   availableSkuRequest: JObject (required)
  ##                      : Filters for showing the available skus.
  ##   location: string (required)
  ##           : The location of the resource
  var path_574366 = newJObject()
  var query_574367 = newJObject()
  var body_574368 = newJObject()
  add(path_574366, "resourceGroupName", newJString(resourceGroupName))
  add(query_574367, "api-version", newJString(apiVersion))
  add(path_574366, "subscriptionId", newJString(subscriptionId))
  if availableSkuRequest != nil:
    body_574368 = availableSkuRequest
  add(path_574366, "location", newJString(location))
  result = call_574365.call(path_574366, query_574367, nil, nil, body_574368)

var serviceListAvailableSkusByResourceGroup* = Call_ServiceListAvailableSkusByResourceGroup_574356(
    name: "serviceListAvailableSkusByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/locations/{location}/availableSkus",
    validator: validate_ServiceListAvailableSkusByResourceGroup_574357, base: "",
    url: url_ServiceListAvailableSkusByResourceGroup_574358,
    schemes: {Scheme.Https})
type
  Call_ServiceValidateInputsByResourceGroup_574369 = ref object of OpenApiRestCall_573667
proc url_ServiceValidateInputsByResourceGroup_574371(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataBox/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/validateInputs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceValidateInputsByResourceGroup_574370(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method does all necessary pre-job creation validation under resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   location: JString (required)
  ##           : The location of the resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574372 = path.getOrDefault("resourceGroupName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "resourceGroupName", valid_574372
  var valid_574373 = path.getOrDefault("subscriptionId")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "subscriptionId", valid_574373
  var valid_574374 = path.getOrDefault("location")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "location", valid_574374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574375 = query.getOrDefault("api-version")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "api-version", valid_574375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   validationRequest: JObject (required)
  ##                    : Inputs of the customer.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574377: Call_ServiceValidateInputsByResourceGroup_574369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method does all necessary pre-job creation validation under resource group.
  ## 
  let valid = call_574377.validator(path, query, header, formData, body)
  let scheme = call_574377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574377.url(scheme.get, call_574377.host, call_574377.base,
                         call_574377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574377, url, valid)

proc call*(call_574378: Call_ServiceValidateInputsByResourceGroup_574369;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          validationRequest: JsonNode; location: string): Recallable =
  ## serviceValidateInputsByResourceGroup
  ## This method does all necessary pre-job creation validation under resource group.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   validationRequest: JObject (required)
  ##                    : Inputs of the customer.
  ##   location: string (required)
  ##           : The location of the resource
  var path_574379 = newJObject()
  var query_574380 = newJObject()
  var body_574381 = newJObject()
  add(path_574379, "resourceGroupName", newJString(resourceGroupName))
  add(query_574380, "api-version", newJString(apiVersion))
  add(path_574379, "subscriptionId", newJString(subscriptionId))
  if validationRequest != nil:
    body_574381 = validationRequest
  add(path_574379, "location", newJString(location))
  result = call_574378.call(path_574379, query_574380, nil, nil, body_574381)

var serviceValidateInputsByResourceGroup* = Call_ServiceValidateInputsByResourceGroup_574369(
    name: "serviceValidateInputsByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBox/locations/{location}/validateInputs",
    validator: validate_ServiceValidateInputsByResourceGroup_574370, base: "",
    url: url_ServiceValidateInputsByResourceGroup_574371, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
