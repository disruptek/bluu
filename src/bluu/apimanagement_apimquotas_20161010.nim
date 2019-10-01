
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2016-10-10
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Quota entity associated with your Azure API Management deployment. To configure call rate limit and quota policies refer to [how to configure call rate limit and quota](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies).
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimquotas"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QuotaByCounterKeysListByService_596679 = ref object of OpenApiRestCall_596457
proc url_QuotaByCounterKeysListByService_596681(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByCounterKeysListByService_596680(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_596854 = path.getOrDefault("quotaCounterKey")
  valid_596854 = validateParameter(valid_596854, JString, required = true,
                                 default = nil)
  if valid_596854 != nil:
    section.add "quotaCounterKey", valid_596854
  var valid_596855 = path.getOrDefault("resourceGroupName")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "resourceGroupName", valid_596855
  var valid_596856 = path.getOrDefault("subscriptionId")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "subscriptionId", valid_596856
  var valid_596857 = path.getOrDefault("serviceName")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "serviceName", valid_596857
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596858 = query.getOrDefault("api-version")
  valid_596858 = validateParameter(valid_596858, JString, required = true,
                                 default = nil)
  if valid_596858 != nil:
    section.add "api-version", valid_596858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596881: Call_QuotaByCounterKeysListByService_596679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_596881.validator(path, query, header, formData, body)
  let scheme = call_596881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596881.url(scheme.get, call_596881.host, call_596881.base,
                         call_596881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596881, url, valid)

proc call*(call_596952: Call_QuotaByCounterKeysListByService_596679;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## quotaByCounterKeysListByService
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_596953 = newJObject()
  var query_596955 = newJObject()
  add(path_596953, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_596953, "resourceGroupName", newJString(resourceGroupName))
  add(query_596955, "api-version", newJString(apiVersion))
  add(path_596953, "subscriptionId", newJString(subscriptionId))
  add(path_596953, "serviceName", newJString(serviceName))
  result = call_596952.call(path_596953, query_596955, nil, nil, nil)

var quotaByCounterKeysListByService* = Call_QuotaByCounterKeysListByService_596679(
    name: "quotaByCounterKeysListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysListByService_596680, base: "",
    url: url_QuotaByCounterKeysListByService_596681, schemes: {Scheme.Https})
type
  Call_QuotaByCounterKeysUpdate_596994 = ref object of OpenApiRestCall_596457
proc url_QuotaByCounterKeysUpdate_596996(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByCounterKeysUpdate_596995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597014 = path.getOrDefault("quotaCounterKey")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "quotaCounterKey", valid_597014
  var valid_597015 = path.getOrDefault("resourceGroupName")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "resourceGroupName", valid_597015
  var valid_597016 = path.getOrDefault("subscriptionId")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "subscriptionId", valid_597016
  var valid_597017 = path.getOrDefault("serviceName")
  valid_597017 = validateParameter(valid_597017, JString, required = true,
                                 default = nil)
  if valid_597017 != nil:
    section.add "serviceName", valid_597017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597018 = query.getOrDefault("api-version")
  valid_597018 = validateParameter(valid_597018, JString, required = true,
                                 default = nil)
  if valid_597018 != nil:
    section.add "api-version", valid_597018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The value of the quota counter to be applied to all quota counter periods.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597020: Call_QuotaByCounterKeysUpdate_596994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  let valid = call_597020.validator(path, query, header, formData, body)
  let scheme = call_597020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597020.url(scheme.get, call_597020.host, call_597020.base,
                         call_597020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597020, url, valid)

proc call*(call_597021: Call_QuotaByCounterKeysUpdate_596994;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## quotaByCounterKeysUpdate
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The value of the quota counter to be applied to all quota counter periods.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597022 = newJObject()
  var query_597023 = newJObject()
  var body_597024 = newJObject()
  add(path_597022, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597022, "resourceGroupName", newJString(resourceGroupName))
  add(query_597023, "api-version", newJString(apiVersion))
  add(path_597022, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597024 = parameters
  add(path_597022, "serviceName", newJString(serviceName))
  result = call_597021.call(path_597022, query_597023, nil, nil, body_597024)

var quotaByCounterKeysUpdate* = Call_QuotaByCounterKeysUpdate_596994(
    name: "quotaByCounterKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysUpdate_596995, base: "",
    url: url_QuotaByCounterKeysUpdate_596996, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysGet_597025 = ref object of OpenApiRestCall_596457
proc url_QuotaByPeriodKeysGet_597027(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  assert "quotaPeriodKey" in path, "`quotaPeriodKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysGet_597026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   quotaPeriodKey: JString (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597028 = path.getOrDefault("quotaCounterKey")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "quotaCounterKey", valid_597028
  var valid_597029 = path.getOrDefault("resourceGroupName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "resourceGroupName", valid_597029
  var valid_597030 = path.getOrDefault("quotaPeriodKey")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "quotaPeriodKey", valid_597030
  var valid_597031 = path.getOrDefault("subscriptionId")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "subscriptionId", valid_597031
  var valid_597032 = path.getOrDefault("serviceName")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "serviceName", valid_597032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597033 = query.getOrDefault("api-version")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "api-version", valid_597033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597034: Call_QuotaByPeriodKeysGet_597025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_597034.validator(path, query, header, formData, body)
  let scheme = call_597034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597034.url(scheme.get, call_597034.host, call_597034.base,
                         call_597034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597034, url, valid)

proc call*(call_597035: Call_QuotaByPeriodKeysGet_597025; quotaCounterKey: string;
          resourceGroupName: string; apiVersion: string; quotaPeriodKey: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## quotaByPeriodKeysGet
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   quotaPeriodKey: string (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597036 = newJObject()
  var query_597037 = newJObject()
  add(path_597036, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597036, "resourceGroupName", newJString(resourceGroupName))
  add(query_597037, "api-version", newJString(apiVersion))
  add(path_597036, "quotaPeriodKey", newJString(quotaPeriodKey))
  add(path_597036, "subscriptionId", newJString(subscriptionId))
  add(path_597036, "serviceName", newJString(serviceName))
  result = call_597035.call(path_597036, query_597037, nil, nil, nil)

var quotaByPeriodKeysGet* = Call_QuotaByPeriodKeysGet_597025(
    name: "quotaByPeriodKeysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysGet_597026, base: "",
    url: url_QuotaByPeriodKeysGet_597027, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysUpdate_597038 = ref object of OpenApiRestCall_596457
proc url_QuotaByPeriodKeysUpdate_597040(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  assert "quotaPeriodKey" in path, "`quotaPeriodKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysUpdate_597039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   quotaPeriodKey: JString (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597041 = path.getOrDefault("quotaCounterKey")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "quotaCounterKey", valid_597041
  var valid_597042 = path.getOrDefault("resourceGroupName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "resourceGroupName", valid_597042
  var valid_597043 = path.getOrDefault("quotaPeriodKey")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "quotaPeriodKey", valid_597043
  var valid_597044 = path.getOrDefault("subscriptionId")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "subscriptionId", valid_597044
  var valid_597045 = path.getOrDefault("serviceName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "serviceName", valid_597045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597046 = query.getOrDefault("api-version")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "api-version", valid_597046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The value of the Quota counter to be applied on the specified period.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597048: Call_QuotaByPeriodKeysUpdate_597038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  let valid = call_597048.validator(path, query, header, formData, body)
  let scheme = call_597048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597048.url(scheme.get, call_597048.host, call_597048.base,
                         call_597048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597048, url, valid)

proc call*(call_597049: Call_QuotaByPeriodKeysUpdate_597038;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          quotaPeriodKey: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## quotaByPeriodKeysUpdate
  ## Updates an existing quota counter value in the specified service instance.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   quotaPeriodKey: string (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The value of the Quota counter to be applied on the specified period.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597050 = newJObject()
  var query_597051 = newJObject()
  var body_597052 = newJObject()
  add(path_597050, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597050, "resourceGroupName", newJString(resourceGroupName))
  add(query_597051, "api-version", newJString(apiVersion))
  add(path_597050, "quotaPeriodKey", newJString(quotaPeriodKey))
  add(path_597050, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597052 = parameters
  add(path_597050, "serviceName", newJString(serviceName))
  result = call_597049.call(path_597050, query_597051, nil, nil, body_597052)

var quotaByPeriodKeysUpdate* = Call_QuotaByPeriodKeysUpdate_597038(
    name: "quotaByPeriodKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysUpdate_597039, base: "",
    url: url_QuotaByPeriodKeysUpdate_597040, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
