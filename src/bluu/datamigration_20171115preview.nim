
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Data Migration Service Resource Provider
## version: 2017-11-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Data Migration Service helps people migrate their data from on-premise database servers to Azure, or from older database software to newer software. The service manages one or more workers that are joined to a customer's virtual network, which is assumed to provide connectivity to their databases. To avoid frequent updates to the resource provider, data migration tasks are implemented by the resource provider in a generic way as task resources, each of which has a task type (which identifies the type of work to run), input, and output. The client is responsible for providing appropriate task type and inputs, which will be passed through unexamined to the machines that implement the functionality, and for understanding the output, which is passed back unexamined to the client.
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "datamigration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all available actions exposed by the Data Migration Service resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available actions exposed by the Data Migration Service resource provider.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all available actions exposed by the Data Migration Service resource provider.
  ##   apiVersion: string (required)
  ##             : Version of the API
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataMigration/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_568175 = ref object of OpenApiRestCall_567657
proc url_ServicesCheckNameAvailability_568177(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckNameAvailability_568176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method checks whether a proposed top-level resource name is valid and available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   location: JString (required)
  ##           : The Azure region of the operation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568192 = path.getOrDefault("subscriptionId")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "subscriptionId", valid_568192
  var valid_568193 = path.getOrDefault("location")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "location", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_ServicesCheckNameAvailability_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method checks whether a proposed top-level resource name is valid and available.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_ServicesCheckNameAvailability_568175;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          location: string): Recallable =
  ## servicesCheckNameAvailability
  ## This method checks whether a proposed top-level resource name is valid and available.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  ##   location: string (required)
  ##           : The Azure region of the operation
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  var body_568200 = newJObject()
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568200 = parameters
  add(path_568198, "location", newJString(location))
  result = call_568197.call(path_568198, query_568199, nil, nil, body_568200)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_568175(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/locations/{location}/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_568176, base: "",
    url: url_ServicesCheckNameAvailability_568177, schemes: {Scheme.Https})
type
  Call_UsagesList_568201 = ref object of OpenApiRestCall_567657
proc url_UsagesList_568203(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesList_568202(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   location: JString (required)
  ##           : The Azure region of the operation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568204 = path.getOrDefault("subscriptionId")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "subscriptionId", valid_568204
  var valid_568205 = path.getOrDefault("location")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "location", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_UsagesList_568201; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_UsagesList_568201; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   location: string (required)
  ##           : The Azure region of the operation
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  add(path_568209, "location", newJString(location))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var usagesList* = Call_UsagesList_568201(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/locations/{location}/usages",
                                      validator: validate_UsagesList_568202,
                                      base: "", url: url_UsagesList_568203,
                                      schemes: {Scheme.Https})
type
  Call_ServicesList_568211 = ref object of OpenApiRestCall_567657
proc url_ServicesList_568213(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataMigration/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesList_568212(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_ServicesList_568211; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_ServicesList_568211; apiVersion: string;
          subscriptionId: string): Recallable =
  ## servicesList
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var servicesList* = Call_ServicesList_568211(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/services",
    validator: validate_ServicesList_568212, base: "", url: url_ServicesList_568213,
    schemes: {Scheme.Https})
type
  Call_ResourceSkusListSkus_568220 = ref object of OpenApiRestCall_567657
proc url_ResourceSkusListSkus_568222(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataMigration/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceSkusListSkus_568221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The skus action returns the list of SKUs that DMS supports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_ResourceSkusListSkus_568220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The skus action returns the list of SKUs that DMS supports.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_ResourceSkusListSkus_568220; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceSkusListSkus
  ## The skus action returns the list of SKUs that DMS supports.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var resourceSkusListSkus* = Call_ResourceSkusListSkus_568220(
    name: "resourceSkusListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/skus",
    validator: validate_ResourceSkusListSkus_568221, base: "",
    url: url_ResourceSkusListSkus_568222, schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_568229 = ref object of OpenApiRestCall_567657
proc url_ServicesListByResourceGroup_568231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListByResourceGroup_568230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  var valid_568233 = path.getOrDefault("groupName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "groupName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_ServicesListByResourceGroup_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_ServicesListByResourceGroup_568229;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## servicesListByResourceGroup
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "groupName", newJString(groupName))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_568229(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services",
    validator: validate_ServicesListByResourceGroup_568230, base: "",
    url: url_ServicesListByResourceGroup_568231, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_568250 = ref object of OpenApiRestCall_567657
proc url_ServicesCreateOrUpdate_568252(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreateOrUpdate_568251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  var valid_568254 = path.getOrDefault("groupName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "groupName", valid_568254
  var valid_568255 = path.getOrDefault("serviceName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "serviceName", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the service
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_ServicesCreateOrUpdate_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_ServicesCreateOrUpdate_568250; apiVersion: string;
          subscriptionId: string; groupName: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## servicesCreateOrUpdate
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   parameters: JObject (required)
  ##             : Information about the service
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  var body_568262 = newJObject()
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "subscriptionId", newJString(subscriptionId))
  add(path_568260, "groupName", newJString(groupName))
  if parameters != nil:
    body_568262 = parameters
  add(path_568260, "serviceName", newJString(serviceName))
  result = call_568259.call(path_568260, query_568261, nil, nil, body_568262)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_568250(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesCreateOrUpdate_568251, base: "",
    url: url_ServicesCreateOrUpdate_568252, schemes: {Scheme.Https})
type
  Call_ServicesGet_568239 = ref object of OpenApiRestCall_567657
proc url_ServicesGet_568241(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_568240(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  var valid_568243 = path.getOrDefault("groupName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "groupName", valid_568243
  var valid_568244 = path.getOrDefault("serviceName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "serviceName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_ServicesGet_568239; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ## 
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_ServicesGet_568239; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesGet
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  add(query_568249, "api-version", newJString(apiVersion))
  add(path_568248, "subscriptionId", newJString(subscriptionId))
  add(path_568248, "groupName", newJString(groupName))
  add(path_568248, "serviceName", newJString(serviceName))
  result = call_568247.call(path_568248, query_568249, nil, nil, nil)

var servicesGet* = Call_ServicesGet_568239(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
                                        validator: validate_ServicesGet_568240,
                                        base: "", url: url_ServicesGet_568241,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_568275 = ref object of OpenApiRestCall_567657
proc url_ServicesUpdate_568277(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdate_568276(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("groupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "groupName", valid_568279
  var valid_568280 = path.getOrDefault("serviceName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "serviceName", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the service
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_ServicesUpdate_568275; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_ServicesUpdate_568275; apiVersion: string;
          subscriptionId: string; groupName: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## servicesUpdate
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   parameters: JObject (required)
  ##             : Information about the service
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  var body_568287 = newJObject()
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  add(path_568285, "groupName", newJString(groupName))
  if parameters != nil:
    body_568287 = parameters
  add(path_568285, "serviceName", newJString(serviceName))
  result = call_568284.call(path_568285, query_568286, nil, nil, body_568287)

var servicesUpdate* = Call_ServicesUpdate_568275(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesUpdate_568276, base: "", url: url_ServicesUpdate_568277,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_568263 = ref object of OpenApiRestCall_567657
proc url_ServicesDelete_568265(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_568264(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568266 = path.getOrDefault("subscriptionId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "subscriptionId", valid_568266
  var valid_568267 = path.getOrDefault("groupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "groupName", valid_568267
  var valid_568268 = path.getOrDefault("serviceName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "serviceName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  var valid_568270 = query.getOrDefault("deleteRunningTasks")
  valid_568270 = validateParameter(valid_568270, JBool, required = false, default = nil)
  if valid_568270 != nil:
    section.add "deleteRunningTasks", valid_568270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_ServicesDelete_568263; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_ServicesDelete_568263; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string;
          deleteRunningTasks: bool = false): Recallable =
  ## servicesDelete
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  add(path_568273, "groupName", newJString(groupName))
  add(query_568274, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_568273, "serviceName", newJString(serviceName))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_568263(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesDelete_568264, base: "", url: url_ServicesDelete_568265,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckChildrenNameAvailability_568288 = ref object of OpenApiRestCall_567657
proc url_ServicesCheckChildrenNameAvailability_568290(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckChildrenNameAvailability_568289(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method checks whether a proposed nested resource name is valid and available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("groupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "groupName", valid_568292
  var valid_568293 = path.getOrDefault("serviceName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "serviceName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_ServicesCheckChildrenNameAvailability_568288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method checks whether a proposed nested resource name is valid and available.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_ServicesCheckChildrenNameAvailability_568288;
          apiVersion: string; subscriptionId: string; groupName: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## servicesCheckChildrenNameAvailability
  ## This method checks whether a proposed nested resource name is valid and available.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  var body_568300 = newJObject()
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  add(path_568298, "groupName", newJString(groupName))
  if parameters != nil:
    body_568300 = parameters
  add(path_568298, "serviceName", newJString(serviceName))
  result = call_568297.call(path_568298, query_568299, nil, nil, body_568300)

var servicesCheckChildrenNameAvailability* = Call_ServicesCheckChildrenNameAvailability_568288(
    name: "servicesCheckChildrenNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/checkNameAvailability",
    validator: validate_ServicesCheckChildrenNameAvailability_568289, base: "",
    url: url_ServicesCheckChildrenNameAvailability_568290, schemes: {Scheme.Https})
type
  Call_ServicesCheckStatus_568301 = ref object of OpenApiRestCall_567657
proc url_ServicesCheckStatus_568303(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/checkStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckStatus_568302(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  var valid_568305 = path.getOrDefault("groupName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "groupName", valid_568305
  var valid_568306 = path.getOrDefault("serviceName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "serviceName", valid_568306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568307 = query.getOrDefault("api-version")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "api-version", valid_568307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568308: Call_ServicesCheckStatus_568301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_ServicesCheckStatus_568301; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesCheckStatus
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  add(query_568311, "api-version", newJString(apiVersion))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  add(path_568310, "groupName", newJString(groupName))
  add(path_568310, "serviceName", newJString(serviceName))
  result = call_568309.call(path_568310, query_568311, nil, nil, nil)

var servicesCheckStatus* = Call_ServicesCheckStatus_568301(
    name: "servicesCheckStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/checkStatus",
    validator: validate_ServicesCheckStatus_568302, base: "",
    url: url_ServicesCheckStatus_568303, schemes: {Scheme.Https})
type
  Call_ProjectsList_568312 = ref object of OpenApiRestCall_567657
proc url_ProjectsList_568314(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsList_568313(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  var valid_568316 = path.getOrDefault("groupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "groupName", valid_568316
  var valid_568317 = path.getOrDefault("serviceName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "serviceName", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_ProjectsList_568312; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_ProjectsList_568312; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## projectsList
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  add(path_568321, "groupName", newJString(groupName))
  add(path_568321, "serviceName", newJString(serviceName))
  result = call_568320.call(path_568321, query_568322, nil, nil, nil)

var projectsList* = Call_ProjectsList_568312(name: "projectsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects",
    validator: validate_ProjectsList_568313, base: "", url: url_ProjectsList_568314,
    schemes: {Scheme.Https})
type
  Call_ProjectsCreateOrUpdate_568335 = ref object of OpenApiRestCall_567657
proc url_ProjectsCreateOrUpdate_568337(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsCreateOrUpdate_568336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568338 = path.getOrDefault("subscriptionId")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "subscriptionId", valid_568338
  var valid_568339 = path.getOrDefault("groupName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "groupName", valid_568339
  var valid_568340 = path.getOrDefault("projectName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "projectName", valid_568340
  var valid_568341 = path.getOrDefault("serviceName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "serviceName", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the project
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_ProjectsCreateOrUpdate_568335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_ProjectsCreateOrUpdate_568335; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## projectsCreateOrUpdate
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  var body_568348 = newJObject()
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  add(path_568346, "groupName", newJString(groupName))
  add(path_568346, "projectName", newJString(projectName))
  if parameters != nil:
    body_568348 = parameters
  add(path_568346, "serviceName", newJString(serviceName))
  result = call_568345.call(path_568346, query_568347, nil, nil, body_568348)

var projectsCreateOrUpdate* = Call_ProjectsCreateOrUpdate_568335(
    name: "projectsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsCreateOrUpdate_568336, base: "",
    url: url_ProjectsCreateOrUpdate_568337, schemes: {Scheme.Https})
type
  Call_ProjectsGet_568323 = ref object of OpenApiRestCall_567657
proc url_ProjectsGet_568325(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGet_568324(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568326 = path.getOrDefault("subscriptionId")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "subscriptionId", valid_568326
  var valid_568327 = path.getOrDefault("groupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "groupName", valid_568327
  var valid_568328 = path.getOrDefault("projectName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "projectName", valid_568328
  var valid_568329 = path.getOrDefault("serviceName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "serviceName", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_ProjectsGet_568323; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_ProjectsGet_568323; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          serviceName: string): Recallable =
  ## projectsGet
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  add(path_568333, "groupName", newJString(groupName))
  add(path_568333, "projectName", newJString(projectName))
  add(path_568333, "serviceName", newJString(serviceName))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_568323(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
                                        validator: validate_ProjectsGet_568324,
                                        base: "", url: url_ProjectsGet_568325,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_568362 = ref object of OpenApiRestCall_567657
proc url_ProjectsUpdate_568364(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsUpdate_568363(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  var valid_568366 = path.getOrDefault("groupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "groupName", valid_568366
  var valid_568367 = path.getOrDefault("projectName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "projectName", valid_568367
  var valid_568368 = path.getOrDefault("serviceName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "serviceName", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the project
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568371: Call_ProjectsUpdate_568362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ## 
  let valid = call_568371.validator(path, query, header, formData, body)
  let scheme = call_568371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568371.url(scheme.get, call_568371.host, call_568371.base,
                         call_568371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568371, url, valid)

proc call*(call_568372: Call_ProjectsUpdate_568362; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## projectsUpdate
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568373 = newJObject()
  var query_568374 = newJObject()
  var body_568375 = newJObject()
  add(query_568374, "api-version", newJString(apiVersion))
  add(path_568373, "subscriptionId", newJString(subscriptionId))
  add(path_568373, "groupName", newJString(groupName))
  add(path_568373, "projectName", newJString(projectName))
  if parameters != nil:
    body_568375 = parameters
  add(path_568373, "serviceName", newJString(serviceName))
  result = call_568372.call(path_568373, query_568374, nil, nil, body_568375)

var projectsUpdate* = Call_ProjectsUpdate_568362(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsUpdate_568363, base: "", url: url_ProjectsUpdate_568364,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_568349 = ref object of OpenApiRestCall_567657
proc url_ProjectsDelete_568351(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsDelete_568350(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  var valid_568353 = path.getOrDefault("groupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "groupName", valid_568353
  var valid_568354 = path.getOrDefault("projectName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "projectName", valid_568354
  var valid_568355 = path.getOrDefault("serviceName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "serviceName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  var valid_568357 = query.getOrDefault("deleteRunningTasks")
  valid_568357 = validateParameter(valid_568357, JBool, required = false, default = nil)
  if valid_568357 != nil:
    section.add "deleteRunningTasks", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_ProjectsDelete_568349; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_ProjectsDelete_568349; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          serviceName: string; deleteRunningTasks: bool = false): Recallable =
  ## projectsDelete
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  add(path_568360, "groupName", newJString(groupName))
  add(query_568361, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_568360, "projectName", newJString(projectName))
  add(path_568360, "serviceName", newJString(serviceName))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_568349(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsDelete_568350, base: "", url: url_ProjectsDelete_568351,
    schemes: {Scheme.Https})
type
  Call_TasksList_568376 = ref object of OpenApiRestCall_567657
proc url_TasksList_568378(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksList_568377(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  var valid_568380 = path.getOrDefault("groupName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "groupName", valid_568380
  var valid_568381 = path.getOrDefault("projectName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "projectName", valid_568381
  var valid_568382 = path.getOrDefault("serviceName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "serviceName", valid_568382
  result.add "path", section
  ## parameters in `query` object:
  ##   taskType: JString
  ##           : Filter tasks by task type
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  var valid_568383 = query.getOrDefault("taskType")
  valid_568383 = validateParameter(valid_568383, JString, required = false,
                                 default = nil)
  if valid_568383 != nil:
    section.add "taskType", valid_568383
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568384 = query.getOrDefault("api-version")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "api-version", valid_568384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568385: Call_TasksList_568376; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ## 
  let valid = call_568385.validator(path, query, header, formData, body)
  let scheme = call_568385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568385.url(scheme.get, call_568385.host, call_568385.base,
                         call_568385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568385, url, valid)

proc call*(call_568386: Call_TasksList_568376; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          serviceName: string; taskType: string = ""): Recallable =
  ## tasksList
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ##   taskType: string
  ##           : Filter tasks by task type
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568387 = newJObject()
  var query_568388 = newJObject()
  add(query_568388, "taskType", newJString(taskType))
  add(query_568388, "api-version", newJString(apiVersion))
  add(path_568387, "subscriptionId", newJString(subscriptionId))
  add(path_568387, "groupName", newJString(groupName))
  add(path_568387, "projectName", newJString(projectName))
  add(path_568387, "serviceName", newJString(serviceName))
  result = call_568386.call(path_568387, query_568388, nil, nil, nil)

var tasksList* = Call_TasksList_568376(name: "tasksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks",
                                    validator: validate_TasksList_568377,
                                    base: "", url: url_TasksList_568378,
                                    schemes: {Scheme.Https})
type
  Call_TasksCreateOrUpdate_568404 = ref object of OpenApiRestCall_567657
proc url_TasksCreateOrUpdate_568406(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksCreateOrUpdate_568405(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568407 = path.getOrDefault("subscriptionId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "subscriptionId", valid_568407
  var valid_568408 = path.getOrDefault("groupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "groupName", valid_568408
  var valid_568409 = path.getOrDefault("taskName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "taskName", valid_568409
  var valid_568410 = path.getOrDefault("projectName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "projectName", valid_568410
  var valid_568411 = path.getOrDefault("serviceName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "serviceName", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the task
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_TasksCreateOrUpdate_568404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_TasksCreateOrUpdate_568404; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; parameters: JsonNode; serviceName: string): Recallable =
  ## tasksCreateOrUpdate
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the task
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  var body_568418 = newJObject()
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  add(path_568416, "groupName", newJString(groupName))
  add(path_568416, "taskName", newJString(taskName))
  add(path_568416, "projectName", newJString(projectName))
  if parameters != nil:
    body_568418 = parameters
  add(path_568416, "serviceName", newJString(serviceName))
  result = call_568415.call(path_568416, query_568417, nil, nil, body_568418)

var tasksCreateOrUpdate* = Call_TasksCreateOrUpdate_568404(
    name: "tasksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
    validator: validate_TasksCreateOrUpdate_568405, base: "",
    url: url_TasksCreateOrUpdate_568406, schemes: {Scheme.Https})
type
  Call_TasksGet_568389 = ref object of OpenApiRestCall_567657
proc url_TasksGet_568391(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGet_568390(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568393 = path.getOrDefault("subscriptionId")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "subscriptionId", valid_568393
  var valid_568394 = path.getOrDefault("groupName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "groupName", valid_568394
  var valid_568395 = path.getOrDefault("taskName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "taskName", valid_568395
  var valid_568396 = path.getOrDefault("projectName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "projectName", valid_568396
  var valid_568397 = path.getOrDefault("serviceName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "serviceName", valid_568397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   $expand: JString
  ##          : Expand the response
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568398 = query.getOrDefault("api-version")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "api-version", valid_568398
  var valid_568399 = query.getOrDefault("$expand")
  valid_568399 = validateParameter(valid_568399, JString, required = false,
                                 default = nil)
  if valid_568399 != nil:
    section.add "$expand", valid_568399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_TasksGet_568389; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_TasksGet_568389; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; serviceName: string; Expand: string = ""): Recallable =
  ## tasksGet
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   Expand: string
  ##         : Expand the response
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(query_568403, "api-version", newJString(apiVersion))
  add(query_568403, "$expand", newJString(Expand))
  add(path_568402, "subscriptionId", newJString(subscriptionId))
  add(path_568402, "groupName", newJString(groupName))
  add(path_568402, "taskName", newJString(taskName))
  add(path_568402, "projectName", newJString(projectName))
  add(path_568402, "serviceName", newJString(serviceName))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var tasksGet* = Call_TasksGet_568389(name: "tasksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                  validator: validate_TasksGet_568390, base: "",
                                  url: url_TasksGet_568391,
                                  schemes: {Scheme.Https})
type
  Call_TasksUpdate_568433 = ref object of OpenApiRestCall_567657
proc url_TasksUpdate_568435(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksUpdate_568434(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568436 = path.getOrDefault("subscriptionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "subscriptionId", valid_568436
  var valid_568437 = path.getOrDefault("groupName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "groupName", valid_568437
  var valid_568438 = path.getOrDefault("taskName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "taskName", valid_568438
  var valid_568439 = path.getOrDefault("projectName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "projectName", valid_568439
  var valid_568440 = path.getOrDefault("serviceName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "serviceName", valid_568440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568441 = query.getOrDefault("api-version")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "api-version", valid_568441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the task
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568443: Call_TasksUpdate_568433; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ## 
  let valid = call_568443.validator(path, query, header, formData, body)
  let scheme = call_568443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568443.url(scheme.get, call_568443.host, call_568443.base,
                         call_568443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568443, url, valid)

proc call*(call_568444: Call_TasksUpdate_568433; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; parameters: JsonNode; serviceName: string): Recallable =
  ## tasksUpdate
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the task
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568445 = newJObject()
  var query_568446 = newJObject()
  var body_568447 = newJObject()
  add(query_568446, "api-version", newJString(apiVersion))
  add(path_568445, "subscriptionId", newJString(subscriptionId))
  add(path_568445, "groupName", newJString(groupName))
  add(path_568445, "taskName", newJString(taskName))
  add(path_568445, "projectName", newJString(projectName))
  if parameters != nil:
    body_568447 = parameters
  add(path_568445, "serviceName", newJString(serviceName))
  result = call_568444.call(path_568445, query_568446, nil, nil, body_568447)

var tasksUpdate* = Call_TasksUpdate_568433(name: "tasksUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                        validator: validate_TasksUpdate_568434,
                                        base: "", url: url_TasksUpdate_568435,
                                        schemes: {Scheme.Https})
type
  Call_TasksDelete_568419 = ref object of OpenApiRestCall_567657
proc url_TasksDelete_568421(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksDelete_568420(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568422 = path.getOrDefault("subscriptionId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "subscriptionId", valid_568422
  var valid_568423 = path.getOrDefault("groupName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "groupName", valid_568423
  var valid_568424 = path.getOrDefault("taskName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "taskName", valid_568424
  var valid_568425 = path.getOrDefault("projectName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "projectName", valid_568425
  var valid_568426 = path.getOrDefault("serviceName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "serviceName", valid_568426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568427 = query.getOrDefault("api-version")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "api-version", valid_568427
  var valid_568428 = query.getOrDefault("deleteRunningTasks")
  valid_568428 = validateParameter(valid_568428, JBool, required = false, default = nil)
  if valid_568428 != nil:
    section.add "deleteRunningTasks", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568429: Call_TasksDelete_568419; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ## 
  let valid = call_568429.validator(path, query, header, formData, body)
  let scheme = call_568429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568429.url(scheme.get, call_568429.host, call_568429.base,
                         call_568429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568429, url, valid)

proc call*(call_568430: Call_TasksDelete_568419; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; serviceName: string; deleteRunningTasks: bool = false): Recallable =
  ## tasksDelete
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568431 = newJObject()
  var query_568432 = newJObject()
  add(query_568432, "api-version", newJString(apiVersion))
  add(path_568431, "subscriptionId", newJString(subscriptionId))
  add(path_568431, "groupName", newJString(groupName))
  add(path_568431, "taskName", newJString(taskName))
  add(query_568432, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_568431, "projectName", newJString(projectName))
  add(path_568431, "serviceName", newJString(serviceName))
  result = call_568430.call(path_568431, query_568432, nil, nil, nil)

var tasksDelete* = Call_TasksDelete_568419(name: "tasksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                        validator: validate_TasksDelete_568420,
                                        base: "", url: url_TasksDelete_568421,
                                        schemes: {Scheme.Https})
type
  Call_TasksCancel_568448 = ref object of OpenApiRestCall_567657
proc url_TasksCancel_568450(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksCancel_568449(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568451 = path.getOrDefault("subscriptionId")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "subscriptionId", valid_568451
  var valid_568452 = path.getOrDefault("groupName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "groupName", valid_568452
  var valid_568453 = path.getOrDefault("taskName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "taskName", valid_568453
  var valid_568454 = path.getOrDefault("projectName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "projectName", valid_568454
  var valid_568455 = path.getOrDefault("serviceName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "serviceName", valid_568455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568456 = query.getOrDefault("api-version")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "api-version", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568457: Call_TasksCancel_568448; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ## 
  let valid = call_568457.validator(path, query, header, formData, body)
  let scheme = call_568457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568457.url(scheme.get, call_568457.host, call_568457.base,
                         call_568457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568457, url, valid)

proc call*(call_568458: Call_TasksCancel_568448; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; serviceName: string): Recallable =
  ## tasksCancel
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568459 = newJObject()
  var query_568460 = newJObject()
  add(query_568460, "api-version", newJString(apiVersion))
  add(path_568459, "subscriptionId", newJString(subscriptionId))
  add(path_568459, "groupName", newJString(groupName))
  add(path_568459, "taskName", newJString(taskName))
  add(path_568459, "projectName", newJString(projectName))
  add(path_568459, "serviceName", newJString(serviceName))
  result = call_568458.call(path_568459, query_568460, nil, nil, nil)

var tasksCancel* = Call_TasksCancel_568448(name: "tasksCancel",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}/cancel",
                                        validator: validate_TasksCancel_568449,
                                        base: "", url: url_TasksCancel_568450,
                                        schemes: {Scheme.Https})
type
  Call_ServicesListSkus_568461 = ref object of OpenApiRestCall_567657
proc url_ServicesListSkus_568463(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListSkus_568462(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568464 = path.getOrDefault("subscriptionId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "subscriptionId", valid_568464
  var valid_568465 = path.getOrDefault("groupName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "groupName", valid_568465
  var valid_568466 = path.getOrDefault("serviceName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "serviceName", valid_568466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568467 = query.getOrDefault("api-version")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "api-version", valid_568467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568468: Call_ServicesListSkus_568461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ## 
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_ServicesListSkus_568461; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesListSkus
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  add(query_568471, "api-version", newJString(apiVersion))
  add(path_568470, "subscriptionId", newJString(subscriptionId))
  add(path_568470, "groupName", newJString(groupName))
  add(path_568470, "serviceName", newJString(serviceName))
  result = call_568469.call(path_568470, query_568471, nil, nil, nil)

var servicesListSkus* = Call_ServicesListSkus_568461(name: "servicesListSkus",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/skus",
    validator: validate_ServicesListSkus_568462, base: "",
    url: url_ServicesListSkus_568463, schemes: {Scheme.Https})
type
  Call_ServicesStart_568472 = ref object of OpenApiRestCall_567657
proc url_ServicesStart_568474(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesStart_568473(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568475 = path.getOrDefault("subscriptionId")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "subscriptionId", valid_568475
  var valid_568476 = path.getOrDefault("groupName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "groupName", valid_568476
  var valid_568477 = path.getOrDefault("serviceName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "serviceName", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568478 = query.getOrDefault("api-version")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "api-version", valid_568478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568479: Call_ServicesStart_568472; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ## 
  let valid = call_568479.validator(path, query, header, formData, body)
  let scheme = call_568479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568479.url(scheme.get, call_568479.host, call_568479.base,
                         call_568479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568479, url, valid)

proc call*(call_568480: Call_ServicesStart_568472; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesStart
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568481 = newJObject()
  var query_568482 = newJObject()
  add(query_568482, "api-version", newJString(apiVersion))
  add(path_568481, "subscriptionId", newJString(subscriptionId))
  add(path_568481, "groupName", newJString(groupName))
  add(path_568481, "serviceName", newJString(serviceName))
  result = call_568480.call(path_568481, query_568482, nil, nil, nil)

var servicesStart* = Call_ServicesStart_568472(name: "servicesStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/start",
    validator: validate_ServicesStart_568473, base: "", url: url_ServicesStart_568474,
    schemes: {Scheme.Https})
type
  Call_ServicesStop_568483 = ref object of OpenApiRestCall_567657
proc url_ServicesStop_568485(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesStop_568484(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568486 = path.getOrDefault("subscriptionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "subscriptionId", valid_568486
  var valid_568487 = path.getOrDefault("groupName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "groupName", valid_568487
  var valid_568488 = path.getOrDefault("serviceName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "serviceName", valid_568488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568489 = query.getOrDefault("api-version")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "api-version", valid_568489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568490: Call_ServicesStop_568483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ## 
  let valid = call_568490.validator(path, query, header, formData, body)
  let scheme = call_568490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568490.url(scheme.get, call_568490.host, call_568490.base,
                         call_568490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568490, url, valid)

proc call*(call_568491: Call_ServicesStop_568483; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesStop
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_568492 = newJObject()
  var query_568493 = newJObject()
  add(query_568493, "api-version", newJString(apiVersion))
  add(path_568492, "subscriptionId", newJString(subscriptionId))
  add(path_568492, "groupName", newJString(groupName))
  add(path_568492, "serviceName", newJString(serviceName))
  result = call_568491.call(path_568492, query_568493, nil, nil, nil)

var servicesStop* = Call_ServicesStop_568483(name: "servicesStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/stop",
    validator: validate_ServicesStop_568484, base: "", url: url_ServicesStop_568485,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
