
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2019-01-01
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimquotas"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QuotaByCounterKeysListByService_593647 = ref object of OpenApiRestCall_593425
proc url_QuotaByCounterKeysListByService_593649(protocol: Scheme; host: string;
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

proc validate_QuotaByCounterKeysListByService_593648(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_593809 = path.getOrDefault("quotaCounterKey")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "quotaCounterKey", valid_593809
  var valid_593810 = path.getOrDefault("resourceGroupName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "resourceGroupName", valid_593810
  var valid_593811 = path.getOrDefault("subscriptionId")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "subscriptionId", valid_593811
  var valid_593812 = path.getOrDefault("serviceName")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "serviceName", valid_593812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593813 = query.getOrDefault("api-version")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "api-version", valid_593813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593840: Call_QuotaByCounterKeysListByService_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_593840.validator(path, query, header, formData, body)
  let scheme = call_593840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593840.url(scheme.get, call_593840.host, call_593840.base,
                         call_593840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593840, url, valid)

proc call*(call_593911: Call_QuotaByCounterKeysListByService_593647;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## quotaByCounterKeysListByService
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593912 = newJObject()
  var query_593914 = newJObject()
  add(path_593912, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_593912, "resourceGroupName", newJString(resourceGroupName))
  add(query_593914, "api-version", newJString(apiVersion))
  add(path_593912, "subscriptionId", newJString(subscriptionId))
  add(path_593912, "serviceName", newJString(serviceName))
  result = call_593911.call(path_593912, query_593914, nil, nil, nil)

var quotaByCounterKeysListByService* = Call_QuotaByCounterKeysListByService_593647(
    name: "quotaByCounterKeysListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysListByService_593648, base: "",
    url: url_QuotaByCounterKeysListByService_593649, schemes: {Scheme.Https})
type
  Call_QuotaByCounterKeysUpdate_593953 = ref object of OpenApiRestCall_593425
proc url_QuotaByCounterKeysUpdate_593955(protocol: Scheme; host: string;
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

proc validate_QuotaByCounterKeysUpdate_593954(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_593973 = path.getOrDefault("quotaCounterKey")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "quotaCounterKey", valid_593973
  var valid_593974 = path.getOrDefault("resourceGroupName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceGroupName", valid_593974
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  var valid_593976 = path.getOrDefault("serviceName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "serviceName", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
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

proc call*(call_593979: Call_QuotaByCounterKeysUpdate_593953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_QuotaByCounterKeysUpdate_593953;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## quotaByCounterKeysUpdate
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
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
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  var body_593983 = newJObject()
  add(path_593981, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_593981, "resourceGroupName", newJString(resourceGroupName))
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593983 = parameters
  add(path_593981, "serviceName", newJString(serviceName))
  result = call_593980.call(path_593981, query_593982, nil, nil, body_593983)

var quotaByCounterKeysUpdate* = Call_QuotaByCounterKeysUpdate_593953(
    name: "quotaByCounterKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysUpdate_593954, base: "",
    url: url_QuotaByCounterKeysUpdate_593955, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysGet_593984 = ref object of OpenApiRestCall_593425
proc url_QuotaByPeriodKeysGet_593986(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/periods/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysGet_593985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
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
  var valid_593987 = path.getOrDefault("quotaCounterKey")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "quotaCounterKey", valid_593987
  var valid_593988 = path.getOrDefault("resourceGroupName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "resourceGroupName", valid_593988
  var valid_593989 = path.getOrDefault("quotaPeriodKey")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "quotaPeriodKey", valid_593989
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  var valid_593991 = path.getOrDefault("serviceName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "serviceName", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_QuotaByPeriodKeysGet_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_QuotaByPeriodKeysGet_593984; quotaCounterKey: string;
          resourceGroupName: string; apiVersion: string; quotaPeriodKey: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## quotaByPeriodKeysGet
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(path_593995, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_593995, "resourceGroupName", newJString(resourceGroupName))
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "quotaPeriodKey", newJString(quotaPeriodKey))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  add(path_593995, "serviceName", newJString(serviceName))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var quotaByPeriodKeysGet* = Call_QuotaByPeriodKeysGet_593984(
    name: "quotaByPeriodKeysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/periods/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysGet_593985, base: "",
    url: url_QuotaByPeriodKeysGet_593986, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysUpdate_593997 = ref object of OpenApiRestCall_593425
proc url_QuotaByPeriodKeysUpdate_593999(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/periods/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysUpdate_593998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
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
  var valid_594000 = path.getOrDefault("quotaCounterKey")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "quotaCounterKey", valid_594000
  var valid_594001 = path.getOrDefault("resourceGroupName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "resourceGroupName", valid_594001
  var valid_594002 = path.getOrDefault("quotaPeriodKey")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "quotaPeriodKey", valid_594002
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  var valid_594004 = path.getOrDefault("serviceName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "serviceName", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "api-version", valid_594005
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

proc call*(call_594007: Call_QuotaByPeriodKeysUpdate_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_QuotaByPeriodKeysUpdate_593997;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          quotaPeriodKey: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## quotaByPeriodKeysUpdate
  ## Updates an existing quota counter value in the specified service instance.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
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
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  var body_594011 = newJObject()
  add(path_594009, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_594009, "resourceGroupName", newJString(resourceGroupName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "quotaPeriodKey", newJString(quotaPeriodKey))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594011 = parameters
  add(path_594009, "serviceName", newJString(serviceName))
  result = call_594008.call(path_594009, query_594010, nil, nil, body_594011)

var quotaByPeriodKeysUpdate* = Call_QuotaByPeriodKeysUpdate_593997(
    name: "quotaByPeriodKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/periods/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysUpdate_593998, base: "",
    url: url_QuotaByPeriodKeysUpdate_593999, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
